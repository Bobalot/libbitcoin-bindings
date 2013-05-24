namespace libbitcoin {

class threadpool
{
public:
    threadpool();
    threadpool(size_t number_threads);
    ~threadpool();

    void spawn();

    void stop();
    void shutdown();
    void join();

    io_service& service();
    const io_service& service() const;

private:
    io_service ios_;
    io_service::work* work_;
    std::vector<std::thread> threads_;
};

class async_strand
{
public:
    async_strand(threadpool& pool);

    template <typename Handler>
    void queue(Handler handler)
    {
        ios_.post(strand_.wrap(handler));
    }

private:
    io_service& ios_;
    io_service::strand strand_;
};

}
