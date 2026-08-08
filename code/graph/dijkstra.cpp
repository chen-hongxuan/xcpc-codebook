using P = pair<long long, int>;
const long long INF = numeric_limits<long long>::max() / 4;

vector<long long> dijkstra(
    int source,
    const vector<vector<pair<int, int>>>& graph
) {
    int n = (int) graph.size();
    vector<long long> dist(n, INF);
    priority_queue<P, vector<P>, greater<P>> pq;

    dist[source] = 0;
    pq.emplace(0, source);
    while (!pq.empty()) {
        auto [du, u] = pq.top();
        pq.pop();
        if (du != dist[u]) continue;

        for (auto [v, weight] : graph[u]) {
            if (dist[v] > du + weight) {
                dist[v] = du + weight;
                pq.emplace(dist[v], v);
            }
        }
    }
    return dist;
}
