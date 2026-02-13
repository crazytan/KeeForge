#ifndef ARGON2_BRIDGE_H
#define ARGON2_BRIDGE_H

#include <stddef.h>
#include <stdint.h>

/// Simplified Argon2 hash function bridged for Swift.
/// variant: 0 = Argon2d, 2 = Argon2id
/// version: 0x13 = v1.3
int32_t argon2_hash(
    uint32_t t_cost,       // time cost (iterations)
    uint32_t m_cost,       // memory cost (KiB)
    uint32_t parallelism,
    const void *pwd, size_t pwdlen,
    const void *salt, size_t saltlen,
    void *hash, size_t hashlen,
    void *encoded, size_t encodedlen,
    int32_t type,          // 0=d, 1=i, 2=id
    uint32_t version
);

#endif /* ARGON2_BRIDGE_H */
