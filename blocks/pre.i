/* EXTRA CRUFT */

/*%rename(errFunc) std::function<void (const std::error_code&)>;*/

/* Found this on internets, not sure it will be useful */
%ignore boost::noncopyable;
namespace boost {
    class noncopyable {};
}

