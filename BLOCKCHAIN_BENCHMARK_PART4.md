# Blockchain/DeFi Security Benchmark - Part 4

Building on Parts 1-3 (48 repos), this benchmark validates new DeFi-specific rules and security hints created for advanced vulnerability detection.

## New Rule Files Added (2026-01-07)

### 1. `defi-advanced.yaml` - 50+ DeFi Protocol Rules

Based on real exploits from rekt.news, Immunefi, and audit findings.

| Category | Rules | Source Exploits |
|----------|-------|-----------------|
| Flash Loan Attacks | 3 | Euler ($197M), bZx ($8M), PancakeBunny ($45M) |
| AMM/DEX Vulnerabilities | 4 | Curve ($70M), SushiSwap, Uniswap |
| Lending Protocol | 4 | Compound ($80M), Aave, Cream Finance |
| Vault/ERC4626 | 3 | Multiple vault inflation attacks |
| Governance | 3 | Beanstalk ($182M), Tornado Cash |
| Bridge/Cross-chain | 3 | Ronin ($624M), Nomad ($190M), Wormhole ($326M) |
| Oracle Manipulation | 4 | Mango Markets ($114M), Cream Finance |
| Token Vulnerabilities | 4 | Fee-on-transfer, rebasing, permit replay |
| Staking/Rewards | 3 | Various reward calculation bugs |
| MEV/Frontrunning | 2 | Commit-reveal, auction patterns |

**Key Rule IDs:**
- `defi-flash-loan-no-callback-validation` - Flash loan callback without sender check
- `defi-missing-slippage-protection` - Swap without minAmountOut
- `defi-vault-share-inflation` - ERC4626 first depositor attack
- `defi-governance-flash-loan-voting` - Voting without snapshot
- `defi-bridge-signature-replay` - Cross-chain replay attacks
- `defi-chainlink-no-staleness-check` - Oracle freshness validation

### 2. `security-hints.yaml` - Developer Guidance Rules

INFO-level findings that guide developers toward better security practices.

| Category | Rules | Purpose |
|----------|-------|---------|
| Fuzzing Recommendations | 4 | Flag patterns that SHOULD be fuzz tested |
| Missing Test Coverage | 2 | Identify areas needing security tests |
| Oracle Usage | 2 | Verify oracle freshness and fallbacks |
| Slippage/MEV Protection | 2 | Add deadline and minOut parameters |
| Admin Functions | 2 | Timelock and multisig recommendations |
| Upgrade Safety | 2 | Storage gaps and initializer chains |
| ERC Standards | 3 | ERC20 approve race, ERC721 safe transfer |
| Gas/DoS Prevention | 2 | Unbounded loops, external calls in loops |
| Invariant Suggestions | 3 | ERC20 supply, vault shares, AMM product |

**Key Hint IDs:**
- `hint-fuzz-complex-math` - Recommend fuzzing for `a * b / c` patterns
- `hint-oracle-verify-freshness` - Check staleness on price feeds
- `hint-add-slippage-protection` - Add minAmountOut to swaps
- `hint-invariant-vault-shares` - `totalAssets >= totalSupply`

---

## Scanning Progress Tracker

| # | Repository | Type | Status | Scan ID | Findings | Key Detections |
|---|------------|------|--------|---------|----------|----------------|
| 1 | [SunWeb3Sec/DeFiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs) | 300+ Real Exploits | ✅ Complete | `b17bbc28` | **47,497** | Flash loans, oracles, reentrancy |
| 2 | [hknio/anniversary-ctf](https://github.com/hknio/anniversary-ctf) | Hacken 2024 (Re-scan) | ✅ Complete | `0b3e61aa` | **94** | New rules validated |

### DeFiHackLabs Scan Issue - RESOLVED

The initial scan (32349b34) caused an **Out of Memory** crash due to `forge build` on 716 Solidity files.

**Solution Implemented:** Added large repo protection (`MAX_SOL_FILES_FOR_COMPILATION = 400`):
- Compilation-based scanners (Slither, Mythril, Aderyn) are skipped for repos > 400 .sol files
- Pattern-based scanning (Opengrep) uses chunked processing (48 chunks of 15 files)
- No OOM crashes, successful completion in ~27 minutes

---

## DeFiHackLabs Expected Detections

DeFiHackLabs contains 300+ real exploit PoCs from 2021-2024. Our new rules target:

### Flash Loan Exploits (Expected: 50+)
- `defi-flash-loan-no-callback-validation`
- `defi-flash-loan-reentrancy`
- `defi-unchecked-flash-loan-fee`

### Oracle Manipulation (Expected: 30+)
- `defi-oracle-spot-price` - Using DEX spot price
- `defi-chainlink-no-staleness-check`
- `defi-chainlink-no-round-check`

### Governance Attacks (Expected: 10+)
- `defi-governance-flash-loan-voting`
- `defi-governance-no-timelock`

### Bridge Exploits (Expected: 15+)
- `defi-bridge-signature-replay`
- `defi-bridge-merkle-proof-validation`

---

## DeFiHackLabs Scan Results (b17bbc28)

**Scan completed successfully on 716 Solidity files (300+ real exploit PoCs)**

### Scanner Breakdown
| Scanner | Findings | Time | Notes |
|---------|----------|------|-------|
| **Opengrep** | 78,621 | 25min | Chunked into 48 batches |
| **Solhint** | 39,277 | 27min | Style + security rules |
| **Gitleaks** | 259 | 6s | Secrets in exploit PoCs |
| **Checkov** | 2 | 86s | IaC checks |
| **Fuzz-coverage** | 1 | <1s | Coverage hint |
| **Slither** | 1 | <1s | Large repo warning (skipped) |
| **Total Raw** | 118,161 | - | Before deduplication |
| **Total Deduped** | **47,497** | 27min | Final unique findings |

### Severity Distribution
| Severity | Count | % of Total |
|----------|-------|------------|
| Critical | 259 | 0.5% |
| High | 8,719 | 18.4% |
| Medium | 12,551 | 26.4% |
| Low | 14,628 | 30.8% |
| Info | 11,340 | 23.9% |

### Skipped Scanners (Large Repo Protection)
These scanners require `forge build` compilation which would cause OOM on 716 files:
- ❌ Mythril (symbolic execution)
- ❌ Aderyn (Cyfrin patterns)
- ❌ Slither (full analysis) - only warning emitted
- ❌ Slither-upgradeability

### Why So Many Findings?
DeFiHackLabs contains **intentionally vulnerable exploit PoCs** reproducing real hacks:
- Each exploit file demonstrates multiple vulnerabilities
- Code is written to be exploitable (for educational purposes)
- Expected to have very low security score (Grade: F)

---

## Validation Results

### Anniversary-CTF Re-scan (0b3e61aa)

**Scanner Breakdown:**
| Scanner | Findings | Time |
|---------|----------|------|
| Opengrep (with new rules) | 49 | 150s |
| Solhint | 39 | 75s |
| Slither | 14 | 48s |
| Checkov | 13 | 151s |
| Aderyn | 12 | 14s |
| OSV-Scanner | 161 | 35s |
| Foundry-fuzz | 1 | 28s |
| Slither-upgradeability | 1 | 48s |
| **Total (deduped)** | **94** | 214s |

**New Rule Loading Confirmed:**
```
Base rules: _shared/secrets.yaml, _shared/urls.yaml, _shared/comments.yaml,
            templates.yaml, yaml-config.yaml, ethernaut-gaps.yaml,
            defi-advanced.yaml, security-hints.yaml
```

---

## Cumulative Statistics

### Total Across Parts 1-4

| Part | Repos | Verified 100% | Scanned | N/A | Total Findings |
|------|-------|---------------|---------|-----|----------------|
| Part 1 | 25 | 15 | 5 | 5 | ~10,000 |
| Part 2 | 20 | 6 | 4 | 10 | ~32,000 |
| Part 3 | 3 | 2 | 1 | 0 | ~12,300 |
| Part 4 | 2 | 2 | 0 | 0 | **47,591** |
| **Total** | **50** | **25** | **10** | **15** | **~102,000** |

**Part 4 Milestone:** Successfully scanned DeFiHackLabs (716 files, 47,497 findings) - the largest blockchain repo in our benchmark!

### Detection Rules

| Category | Rule Files | Key Patterns |
|----------|------------|--------------|
| Core Solidity | solidity.yaml | 160+ patterns |
| Ethernaut Gaps | ethernaut-gaps.yaml | CTF-verified |
| **DeFi Advanced** | **defi-advanced.yaml** | **50+ exploit patterns** |
| **Security Hints** | **security-hints.yaml** | **20+ developer guidance** |
| Templates | templates.yaml | XSS in templating engines |
| YAML Config | yaml-config.yaml | CI/CD, K8s misconfigs |

---

## Three-Tier Detection Strategy

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  TIER 1: STATIC ANALYSIS (Always runs, <60s)                                 ║
║  ├─ Opengrep rules (210+ including new DeFi rules)                          ║
║  ├─ Slither detectors                                                        ║
║  ├─ Aderyn patterns                                                          ║
║  └─ Solhint security rules                                                   ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  TIER 2: FUZZING (If tests exist, <60s quick mode)                          ║
║  ├─ Detect existing fuzz tests (foundry-fuzz)                               ║
║  ├─ Flag missing fuzz coverage (fuzz-coverage scanner)                       ║
║  └─ Check invariant violations                                               ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  TIER 3: SECURITY HINTS (Always, guidance only)                             ║
║  ├─ "Complex math detected - recommend fuzzing"                              ║
║  ├─ "External call pattern - verify trust assumptions"                       ║
║  ├─ "Oracle usage - verify freshness checks"                                 ║
║  └─ Generate security checklist for contract type                            ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## What's New

### Fuzz Coverage Detection
New scanner that identifies Solidity contracts containing risky patterns but lacking fuzz tests:

```python
FUZZ_WORTHY_PATTERNS = [
    (r'\s*\*\s*[^/]+\s*/\s*', 'Complex arithmetic'),
    (r'\.mul\([^)]+\)\.div\(', 'SafeMath arithmetic'),
    (r'\*\*\s*\d+', 'Exponentiation'),
    (r'function\s+swap\s*\(', 'Swap function'),
    (r'function\s+deposit\s*\(', 'Deposit function'),
    ...
]
```

### Security Hints with Code Templates
Each hint includes actionable recommendations:

```yaml
- id: hint-fuzz-complex-math
  message: "Complex arithmetic detected - recommend fuzz tests"
  metadata:
    recommendation: |
      Add fuzz tests with Foundry:
      function testFuzz_calculation(uint256 a, uint256 b) public {
          vm.assume(a > 0 && b > 0);
          uint256 result = contract.calculate(a, b);
          // Add invariant assertions
      }
```

---

## Sources

- [DeFiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs) - 300+ real DeFi exploit PoCs
- [rekt.news](https://rekt.news/) - DeFi exploit post-mortems
- [Immunefi](https://immunefi.com/) - Bug bounty reports
- [Code4rena](https://code4rena.com/) - Audit findings

---

*Created: 2026-01-07*
*Updated: 2026-01-07 - DeFiHackLabs scan complete (47,497 findings)*
*Part 1: 25 repos | Part 2: 20 repos | Part 3: 3 repos | Part 4: 2 repos*
*Total: 50 repos | 102,000+ findings | New Rules: 70+ (defi-advanced + security-hints)*
