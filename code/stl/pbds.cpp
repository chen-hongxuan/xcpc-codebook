#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;

template<class T>
using ordered_set=tree<T,null_type,std::less<T>,
  rb_tree_tag,tree_order_statistics_node_update>;

template<class K,class V>
using hash_table=gp_hash_table<K,V>;
