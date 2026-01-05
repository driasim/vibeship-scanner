# Secureum A-MAZE-X Challenges Deep Verification

**Repo**: https://github.com/secureum/secureum-a-maze-x-challenges
**Scan ID**: `c00aec20-e80a-4c96-8058-b2014407f292`
**Total Findings**: 82
**Status**: COMPLETE

---

## Coverage Summary

```
+----------------------------------------------------------+
| SECUREUM A-MAZE-X COVERAGE VERIFICATION                  |
+----------------------------------------------------------+
| SAST-Detectable Challenges: 5/5                          |
| Challenges with Detections: 5/5 (100%)                   |
+----------------------------------------------------------+
| VERIFIED BLOCKCHAIN-SPECIFIC DETECTION: 5/5 (100%)       |
+----------------------------------------------------------+
```

---

## Scanner Breakdown

| Scanner | Findings | Key Detections |
|---------|----------|----------------|
| **Opengrep** | ~45 | SWC-120, SWC-105, SWC-118, cross-chain replay |
| **Slither** | 7 | arbitrary-send-eth, weak-prng, tx-origin, uninitialized-state |
| **Mythril** | 5 | SWC-101 (integer), SWC-115 (tx.origin), SWC-116 (predictable) |
| **Trivy** | 5 | Dependency CVEs |
| **OSV-Scanner** | 3 | Package vulnerabilities |
| **Gitleaks** | 2 | Secret assignments |
| **Retire.js** | 2 | npm vulnerabilities |

---

## Vulnerability-to-Detection Mapping (5 Challenges)

| # | Challenge | Vulnerability | Status | Rule(s) Detected | Evidence |
|---|-----------|--------------|--------|------------------|----------|
| 1 | **N1-SecureVault** | Weak randomness (SWC-120) | **✅ DETECTED** | `sol-swc-120-keccak-weak-randomness`, `sol-weak-randomness-blockhash`, `slither-weak-prng`, `slither-arbitrary-send-eth` | N1-SecureVault-easy.sol:13,20,22,23,32,50,52,53 |
| 2 | **N2-Weirdo** | ETH handling / locked ether | **✅ DETECTED** | `slither-arbitrary-send-eth`, `slither-locked-ether`, `sol-event-after-external-call` | N2-Weirdo-easy.sol:20,24, N2-Weirdohack-easy.sol:6 |
| 3 | **N3-TimeLock** | Access control bypass, reentrancy | **✅ DETECTED** | `sol-swc-105-unprotected-withdrawal`, `sol-claim-bitmap-after-transfer`, `slither-tx-origin`, `mythril-swc-101`, `mythril-swc-116` | N3-TimeLock-easy.sol:13,20,21,22,23 |
| 4 | **N4-Padlock** | Signature replay attack | **✅ DETECTED** | `sol-cross-chain-replay`, `slither-arbitrary-send-eth`, `sol-send-all-balance` | N4-Padlock-medium.sol:16,25,58,60 |
| 5 | **N5-BecomeMaster** | Constructor typo, tx.origin | **✅ DETECTED** | `sol-modifier-no-underscore`, `sol-swc-118-constructor-typo-pattern`, `slither-uninitialized-state`, `mythril-swc-115` | N5-BecomeMaster-medium.sol:10,17,21,24,25,34 |

---

## Key Blockchain-Specific Detections

### Weak Randomness (SWC-120)
- `sol-swc-120-keccak-weak-randomness` - N1-SecureVault-easy.sol:20,50 ✓
- `sol-weak-randomness-blockhash` - N1-SecureVault-easy.sol:22,23,52,53 ✓
- `slither-weak-prng` - N1-SecureVault-easy.sol:13 ✓

### Access Control (SWC-105)
- `sol-swc-105-unprotected-withdrawal` - N3-TimeLock-easy.sol:20 ✓
- `slither-tx-origin` - N3-TimeLock-easy.sol:20 ✓

### Constructor Issues (SWC-118)
- `sol-swc-118-constructor-typo-pattern` - N5-BecomeMaster-medium.sol:34 ✓
- `sol-modifier-no-underscore` - N5-BecomeMaster-medium.sol:24 ✓

### State Issues
- `slither-uninitialized-state` - N5-BecomeMaster-medium.sol:10 ✓
- `sol-claim-bitmap-after-transfer` - N3-TimeLock-easy.sol:23 ✓

### Cross-Chain/Replay
- `sol-cross-chain-replay` - N4-Padlock-medium.sol:16,25 ✓

### ETH Handling
- `slither-arbitrary-send-eth` - N1:32, N2:20, N4:58 ✓
- `slither-locked-ether` - N2-Weirdohack:6, N5-BecomeMasterhack:6 ✓

### Mythril Deep Analysis
- `mythril-swc-101` (Integer Arithmetic) - N3-TimeLock-easy.sol:13 ✓
- `mythril-swc-115` (tx.origin) - N5-BecomeMaster-medium.sol:17,21,25 ✓
- `mythril-swc-116` (Predictable env) - N3-TimeLock-easy.sol:22 ✓

---

## High-Severity Evidence

| # | File | Line | Rule | Description |
|---|------|------|------|-------------|
| 1 | N1-SecureVault-easy.sol | 20 | `sol-swc-120-keccak-weak-randomness` | keccak256 with block variables |
| 2 | N1-SecureVault-easy.sol | 13 | `slither-weak-prng` | Weak PRNG in constructor |
| 3 | N3-TimeLock-easy.sol | 20 | `sol-swc-105-unprotected-withdrawal` | Anyone can drain funds |
| 4 | N3-TimeLock-easy.sol | 23 | `sol-claim-bitmap-after-transfer` | Reentrancy via claim tracking |
| 5 | N4-Padlock-medium.sol | 16,25 | `sol-cross-chain-replay` | Replay attack possible |
| 6 | N5-BecomeMaster-medium.sol | 34 | `sol-swc-118-constructor-typo-pattern` | Constructor never executes |
| 7 | N5-BecomeMaster-medium.sol | 24 | `sol-modifier-no-underscore` | Function body skipped |
| 8 | N5-BecomeMaster-medium.sol | 10 | `slither-uninitialized-state` | Uninitialized state variable |
| 9 | N3-TimeLock-easy.sol | 13 | `mythril-swc-101` | Integer arithmetic bug |
| 10 | N5-BecomeMaster-medium.sol | 17,21,25 | `mythril-swc-115` | tx.origin dependence |

---

## Scanner Performance Comparison

| Challenge | Opengrep | Slither | Mythril |
|-----------|----------|---------|---------|
| N1-SecureVault | swc-120, blockhash, cross-chain | arbitrary-send-eth, weak-prng | - |
| N2-Weirdo | visibility, event-after-call | arbitrary-send-eth, locked-ether | - |
| N3-TimeLock | swc-105, claim-bitmap, blockhash | tx-origin | swc-101, swc-116 |
| N4-Padlock | cross-chain-replay, send-all-balance | arbitrary-send-eth | - |
| N5-BecomeMaster | modifier-no-underscore, swc-118, redundant | uninitialized-state, locked-ether | swc-115 (3x) |

---

## Notes

1. **Slither working**: Unlike Paradigm CTF, this repo compiled successfully
2. **Mythril working**: Detected integer bugs and tx.origin issues
3. **Multi-scanner coverage**: Each challenge detected by 2-4 scanners
4. **High confidence**: Core vulnerabilities caught by multiple tools

---

*Verified: 2026-01-05*
