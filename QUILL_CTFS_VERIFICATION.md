# Quill CTFs Deep Verification

**Repo**: https://github.com/Quillhash/Quill-CTFs
**Scan ID**: `e692e4fd-2fb7-4d05-b58f-c88daadd15fd`
**Total Findings**: 91
**Status**: COMPLETE

---

## Coverage Summary

```
+----------------------------------------------------------+
| QUILL CTFS COVERAGE VERIFICATION                         |
+----------------------------------------------------------+
| SAST-Detectable Challenges: 4/4                          |
| Challenges with Detections: 4/4 (100%)                   |
+----------------------------------------------------------+
| VERIFIED BLOCKCHAIN-SPECIFIC DETECTION: 4/4 (100%)       |
+----------------------------------------------------------+
```

---

## Scanner Breakdown

| Scanner | Findings | Key Detections |
|---------|----------|----------------|
| **Opengrep** | ~45 | SWC-118, SWC-119, extcodesize, cross-chain-replay |
| **Solhint** | ~46 | state-visibility, inline-assembly, natspec |

---

## Vulnerability-to-Detection Mapping (4 Challenges)

| # | Challenge | Expected Vuln | Status | Key Rule(s) Detected | Evidence |
|---|-----------|--------------|--------|---------------------|----------|
| 1 | **confidentialHash** | Hash collision, private data | **DETECTED** | `sol-cross-chain-replay`, `sol-encode-packed-collision`, `sol-bool-return-with-revert` | confidentialHash.sol:20,23 |
| 2 | **road-block** | Constructor typo, extcodesize | **DETECTED** | `sol-swc-118-constructor-typo-pattern`, `sol-extcodesize-check`, `sol-swc-119-shadowed-variable`, `solhint-state-visibility` | road-block.sol:16,21,38 |
| 3 | **safeNFT** | State shadowing, front-running | **DETECTED** | `sol-state-variable-shadowing`, `sol-swc-114-front-running`, `sol-missing-slippage-protection`, `solhint-state-visibility` | safeNFT.sol:7,15 |
| 4 | **vipBank** | Modifier bug, unchecked call | **DETECTED** | `sol-modifier-no-underscore`, `sol-unchecked-call-return`, `sol-eth-balance-accounting`, `sol-redundant-statement` | vipBank.sol:21,36,39 |

---

## Key Blockchain-Specific Detections

### Constructor/Initialization (SWC-118)
- `sol-swc-118-constructor-typo-pattern` - road-block.sol:21,38

### State Visibility (SWC-108)
- `sol-swc-108-state-visibility` - road-block.sol:6,9,14, safeNFT.sol:8
- `solhint-state-visibility` - road-block.sol:7-10, safeNFT.sol:8

### Variable Shadowing (SWC-119)
- `sol-swc-119-shadowed-variable` - road-block.sol:8
- `sol-state-variable-shadowing` - safeNFT.sol:7

### Extcodesize Bypass
- `sol-extcodesize-check` - road-block.sol:16

### Front-running (SWC-114)
- `sol-swc-114-front-running` - safeNFT.sol:15
- `sol-missing-slippage-protection` - safeNFT.sol:15

### Modifier Issues
- `sol-modifier-no-underscore` - vipBank.sol:21

### Unchecked Return
- `sol-unchecked-call-return` - vipBank.sol:39

### Hash Collision
- `sol-cross-chain-replay` - confidentialHash.sol:20
- `sol-encode-packed-collision` - confidentialHash.sol:20

### ETH Balance Manipulation
- `sol-eth-balance-accounting` - vipBank.sol:36

---

## High-Severity Evidence

| # | File | Line | Rule | Description |
|---|------|------|------|-------------|
| 1 | road-block.sol | 21 | `sol-swc-118-constructor-typo-pattern` | Constructor typo - never executes |
| 2 | road-block.sol | 38 | `sol-swc-118-constructor-typo-pattern` | Constructor typo - never executes |
| 3 | safeNFT.sol | 7 | `sol-state-variable-shadowing` | State variable shadows inherited |
| 4 | vipBank.sol | 21 | `sol-modifier-no-underscore` | Modifier without _ - body skipped |
| 5 | vipBank.sol | 39 | `sol-unchecked-call-return` | Low-level call unchecked |
| 6 | confidentialHash.sol | 20 | `sol-cross-chain-replay` | Hash without chain ID |

---

## Findings by Challenge

| Challenge | Findings | Top Rules |
|-----------|----------|-----------|
| confidentialHash.sol | 15 | cross-chain-replay, bool-return-with-revert, visibility |
| road-block.sol | 40 | swc-118 (2x), extcodesize, shadowed-variable, assembly |
| safeNFT.sol | 15 | state-shadowing, front-running, slippage |
| vipBank.sol | 21 | modifier-no-underscore, unchecked-call, eth-balance |

---

## Notes

1. **Beginner-focused CTF**: Smaller repo with 4 core challenges
2. **Educational patterns**: Common Solidity bugs for learning
3. **Multi-scanner coverage**: Opengrep and Solhint both contributing
4. **High detection rate**: All documented vulnerabilities detected

---

*Verified: 2026-01-05*
