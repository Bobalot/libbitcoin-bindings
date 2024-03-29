#ifndef LIBBITCOIN_PROTOCOL_HPP
#define LIBBITCOIN_PROTOCOL_HPP

#include <memory>
#include <system_error>

#include <bitcoin/types.hpp>
#include <bitcoin/primitives.hpp>
#include <bitcoin/utility/subscriber.hpp>
#include <bitcoin/network/channel.hpp>
#include <bitcoin/threadpool.hpp>

namespace libbitcoin {

class hosts;
class handshake;

class protocol
{
public:
    typedef std::function<void (const std::error_code&)> completion_handler;

    typedef std::function<void (const std::error_code&, size_t)>
        fetch_connection_count_handler;
    typedef std::function<void (const std::error_code&, channel_ptr)> channel_handler;

    protocol(threadpool& pool, hosts& hsts,
        handshake& shake, network& net);

    void start(completion_handler handle_complete);
    void stop(completion_handler handle_complete);

    void bootstrap(completion_handler handle_complete);
    void run();

    void fetch_connection_count(
        fetch_connection_count_handler handle_fetch);
    void subscribe_channel(channel_handler handle_channel);

    template <typename Message>
    void broadcast(const Message& packet)
    {
        strand_.post(
            std::bind(&protocol::do_broadcast<Message>,
                this, packet));
    }

private:
    struct connection_info
    {
        network_address_type address;
        channel_ptr node;
    };
    typedef std::vector<connection_info> connection_list;
    // Accepted connections
    typedef std::vector<channel_ptr> channel_ptr_list;

    typedef subscriber<channel_ptr> channel_subscriber_type;

    // start sequence
    void handle_bootstrap(const std::error_code& ec,
        atomic_counter_ptr count_paths, completion_handler handle_complete);
    void handle_start_handshake_service(const std::error_code& ec,
        atomic_counter_ptr count_paths, completion_handler handle_complete);

    // stop sequence
    void handle_save(const std::error_code& ec,
        completion_handler handle_complete);

    // bootstrap sequence
    void load_hosts(const std::error_code& ec,
        completion_handler handle_complete);
    void if_0_seed(const std::error_code& ec, size_t hosts_count,
        completion_handler handle_complete);

    // seed addresses from dns seeds
    class seeds
      : public std::enable_shared_from_this<seeds>
    {
    public:
        seeds(protocol* parent);
        void start(completion_handler handle_complete);
    private:
        void error_case(const std::error_code& ec);

        void connect_dns_seed(const std::string& hostname);
        void request_addresses(const std::error_code& ec,
            channel_ptr dns_seed_node);
        void handle_send_get_address(const std::error_code& ec);

        void save_addresses(const std::error_code& ec,
            const address_type& packet, channel_ptr);
        void handle_store(const std::error_code& ec);

        completion_handler handle_complete_;
        size_t ended_paths_;
        bool finished_;

        // From parent
        io_service::strand& strand_;
        hosts& hosts_;
        handshake& handshake_;
        network& network_;
    };
    std::shared_ptr<seeds> load_seeds_;
    friend class seeds;

    // run loop
    // Connect outwards
    void try_connect();
    void attempt_connect(const std::error_code& ec,
        const network_address_type& packet);
    void handle_connect(const std::error_code& ec, channel_ptr node,
        const network_address_type& address);

    // Accept inwards connections
    void handle_listen(const std::error_code& ec, acceptor_ptr accept);
    void handle_accept(const std::error_code& ec, channel_ptr node,
        acceptor_ptr accept);

    // Channel setup
    void setup_new_channel(channel_ptr node);
    void channel_stopped(const std::error_code& ec,
        channel_ptr which_node);

    void subscribe_address(channel_ptr node);
    void receive_address_message(const std::error_code& ec,
        const address_type& addr, channel_ptr node);
    void handle_store_address(const std::error_code& ec);

    // fetch methods
    void do_fetch_connection_count(
        fetch_connection_count_handler handle_fetch);

    template <typename Message>
    void do_broadcast(const Message& packet)
    {
        auto null_handle = [](const std::error_code&) { };
        for (const connection_info& connection: connections_)
            connection.node->send(packet, null_handle);
        for (channel_ptr node: accepted_channels_)
            node->send(packet, null_handle);
    }

    io_service::strand strand_;

    const std::string hosts_filename_;
    hosts& hosts_;
    handshake& handshake_;
    network& network_;

    size_t max_outbound_;
    connection_list connections_;
    channel_ptr_list accepted_channels_;

    channel_subscriber_type::ptr channel_subscribe_;
};

} // namespace libbitcoin

#endif

