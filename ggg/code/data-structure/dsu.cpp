struct DSU {
    vector<int> parent, size;

    explicit DSU(int n) : parent(n), size(n, 1) {
        iota(parent.begin(), parent.end(), 0);
    }

    int find(int x) {
        while (x != parent[x]) {
            x = parent[x] = parent[parent[x]];
        }
        return x;
    }

    bool unite(int a, int b) {
        a = find(a), b = find(b);
        if (a == b) return false;
        if (size[a] < size[b]) swap(a, b);
        parent[b] = a;
        size[a] += size[b];
        return true;
    }

    bool same(int a, int b) {
        return find(a) == find(b);
    }
};
