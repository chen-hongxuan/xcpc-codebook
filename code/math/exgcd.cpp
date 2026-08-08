tuple<long long, long long, long long> exgcd(long long a, long long b) {
    if (b == 0) return {a, 1, 0};
    auto [g, x, y] = exgcd(b, a % b);
    return {g, y, x - a / b * y};
}

long long inverse(long long a, long long mod) {
    auto [g, x, y] = exgcd(a, mod);
    assert(g == 1);
    return (x % mod + mod) % mod;
}
