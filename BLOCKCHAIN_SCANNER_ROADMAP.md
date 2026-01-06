# Blockchain & Smart Contract Scanner Improvement Roadmap

## Executive Summary

Our scanner currently achieves **100% coverage on 23 CTF repos** with 160+ Solidity rules. However, real-world DeFi vulnerabilities require more than static analysis. This roadmap outlines how to become the **most trusted smart contract security scanner** for developers and vibe coders in the blockchain ecosystem.

---

## Current State Analysis

### What We Have (16 Scanners)

| Scanner | Type | Strengths | Limitations |
|---------|------|-----------|-------------|
| **Opengrep** | SAST | 160+ custom rules, fast | Pattern-only, no semantics |
| **Slither** | SAST | Taint analysis, detectors | Misses complex DeFi patterns |
| **Aderyn** | SAST | Cyfrin patterns | Limited rule set |
| **Mythril** | Symbolic | Deep analysis | Slow, high false positives |
| **Solhint** | Linter | Code quality | Not security-focused |
| **Echidna** | Fuzzing | Property testing | Needs test files to exist |
| **Foundry Fuzz** | Fuzzing | Fast fuzzing | Needs test files to exist |

### What We're Missing

```
╔══════════════════════════════════════════════════════════════════════════╗
║  VULNERABILITY DETECTION GAP ANALYSIS                                    ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  SAST-DETECTABLE (We're good at these):                                 ║
║  ✅ Reentrancy patterns                                                  ║
║  ✅ Access control issues                                                ║
║  ✅ Integer overflow/underflow                                           ║
║  ✅ Unchecked external calls                                             ║
║  ✅ Tx.origin authentication                                             ║
║  ✅ Selfdestruct vulnerabilities                                         ║
║                                                                          ║
║  SEMANTIC/RUNTIME-ONLY (We can't catch these with SAST):                ║
║  ❌ Business logic errors                                                ║
║  ❌ Economic attacks (sandwich, MEV)                                     ║
║  ❌ Cross-contract state manipulation                                    ║
║  ❌ Assembly/Yul memory corruption                                       ║
║  ❌ Timing-dependent vulnerabilities                                     ║
║  ❌ Oracle price manipulation (needs external data)                      ║
║                                                                          ║
║  PARTIALLY DETECTABLE (We can hint, not prove):                         ║
║  ⚠️ Flash loan attack vectors                                           ║
║  ⚠️ Governance manipulation                                              ║
║  ⚠️ LP share inflation                                                   ║
║  ⚠️ Vault share rounding                                                 ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## Strategy: Three-Tier Detection System

### Tier 1: Static Analysis (Current - Enhance)
**Goal:** Catch all pattern-based vulnerabilities
- Expand Opengrep rules from 160 → 300+
- Add DeFi-specific patterns from real exploits
- Vyper language support

### Tier 2: Fuzzing Integration (New - Implement)
**Goal:** Catch semantic/runtime vulnerabilities
- Quick fuzz campaigns (30 seconds)
- Invariant violation detection
- "Missing fuzz tests" as a finding

### Tier 3: Security Guidance (New - Implement)
**Goal:** Help developers even when we can't auto-detect
- "This pattern SHOULD be fuzzed" hints
- Security checklist generation
- Best practices per contract type

---

## Fuzzing Integration Deep Dive

### The Problem
SmartSecRiddles showed us: **50% of real vulnerabilities can't be caught by SAST**
- Assembly memory bugs
- Business logic errors
- Weak entropy
- State-dependent issues

### The Solution: Hybrid Approach

```
┌─────────────────────────────────────────────────────────────────┐
│                    SCAN REQUEST                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  TIER 1: STATIC ANALYSIS (Always runs, <60s)                    │
│  ├─ Opengrep rules                                              │
│  ├─ Slither detectors                                           │
│  ├─ Aderyn patterns                                             │
│  └─ Solhint security rules                                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  TIER 2: FUZZING (If tests exist, <60s quick mode)              │
│  ├─ Detect existing fuzz tests                                  │
│  ├─ Run quick fuzz campaign (30 iterations)                     │
│  ├─ Check invariant violations                                  │
│  └─ Report: "No fuzz coverage for X" as WARNING                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  TIER 3: SECURITY HINTS (Always, guidance only)                 │
│  ├─ "Complex math detected - recommend fuzzing"                 │
│  ├─ "External call pattern - verify trust assumptions"          │
│  ├─ "Oracle usage - verify freshness checks"                    │
│  └─ Generate security checklist for contract type               │
└─────────────────────────────────────────────────────────────────┘
```

### Fuzzing Implementation Plan

#### Phase 1: Detect Missing Fuzz Coverage (Week 1)
```yaml
# New rule: sol-missing-fuzz-tests
- id: sol-missing-fuzz-tests
  message: "Complex arithmetic without fuzz tests - consider adding invariant tests"
  severity: INFO
  pattern-either:
    - pattern: $A * $B / $C  # Division after multiplication
    - pattern: $A ** $B      # Exponentiation
    - pattern: sqrt(...)     # Square root
    - pattern: mulDiv(...)   # Complex math
  metadata:
    recommendation: "Add fuzz tests with Foundry: function testFuzz_XXX(uint256 x) public"
```

#### Phase 2: Quick Fuzz Execution (Week 2-3)
```python
def run_quick_fuzz(repo_dir: str) -> List[Dict]:
    """Run 30-second fuzz campaign on detected test files"""
    findings = []

    # Find fuzz test files
    fuzz_files = glob.glob(f"{repo_dir}/**/test/**/*.t.sol")

    for test_file in fuzz_files:
        # Run quick fuzz (30 iterations, 30 second timeout)
        result = subprocess.run(
            ["forge", "test", "--match-test", "testFuzz",
             "--fuzz-runs", "30", "-vvv"],
            timeout=30,
            capture_output=True
        )

        if "FAIL" in result.stdout:
            findings.append({
                "rule_id": "foundry-fuzz-failure",
                "severity": "HIGH",
                "message": f"Fuzz test failed: {extract_failure(result)}",
                "file": test_file
            })

    return findings
```

#### Phase 3: Invariant Detection (Week 4)
- Detect contracts WITHOUT invariant tests
- Suggest invariants based on contract type:
  - ERC20: `totalSupply == sum(balances)`
  - Vault: `totalAssets >= totalShares`
  - AMM: `k = reserve0 * reserve1` (constant product)

---

## New Rule Categories Needed

### 1. DeFi Protocol Patterns (`rules/defi-advanced.yaml`)

| Category | Rules Needed | Source |
|----------|--------------|--------|
| Flash Loans | Callback validation, amount checks | Euler, Aave hacks |
| AMM/DEX | Slippage, sandwich protection | Curve, Uniswap |
| Lending | Liquidation, collateral checks | Compound, Aave |
| Vaults | Share inflation, rounding | ERC4626 issues |
| Governance | Vote manipulation, timelock bypass | Beanstalk, Tornado |
| Bridges | Message validation, replay protection | Ronin, Nomad |

### 2. Vyper Support (`rules/vyper.yaml`)

| Pattern | Vyper Syntax |
|---------|--------------|
| Reentrancy | `@nonreentrant` missing |
| Raw calls | `raw_call()` without checks |
| Delegate calls | `delegate_call()` dangers |
| Self-destruct | `selfdestruct()` patterns |

### 3. Security Hints (`rules/security-hints.yaml`)

| Hint | Trigger | Recommendation |
|------|---------|----------------|
| "Fuzz this" | Complex math | Add invariant tests |
| "Verify oracle" | Chainlink usage | Check staleness |
| "Check slippage" | swap() functions | Add minOut param |
| "Timelock this" | Admin functions | Add delay |

---

## Implementation Roadmap

### Phase 1: Foundation (Weeks 1-2)
- [ ] Create `rules/defi-advanced.yaml` with 50+ DeFi rules
- [ ] Create `rules/security-hints.yaml` for guidance
- [ ] Add "missing fuzz coverage" detection
- [ ] Scan DeFiHackLabs repo (300+ exploits)

### Phase 2: Fuzzing Integration (Weeks 3-4)
- [ ] Implement quick fuzz execution (30s campaigns)
- [ ] Parse and report fuzz failures properly
- [ ] Add invariant suggestions per contract type
- [ ] Create fuzz test templates

### Phase 3: Vyper Support (Weeks 5-6)
- [ ] Create `rules/vyper.yaml` with 30+ rules
- [ ] Test against Curve Finance contracts
- [ ] Add Vyper to detected languages

### Phase 4: Real Exploit Mining (Ongoing)
- [ ] Monitor rekt.news for new exploits
- [ ] Add rules within 48h of major hacks
- [ ] Quarterly pattern extraction from Immunefi
- [ ] Community rule contributions

---

## Success Metrics

### Coverage Targets

| Metric | Current | Target (3 months) |
|--------|---------|-------------------|
| Solidity rules | 160 | 300+ |
| Vyper rules | 0 | 50+ |
| DeFi-specific rules | ~30 | 100+ |
| Verified benchmark repos | 23 | 50+ |
| Real exploit coverage | Unknown | 80%+ of top 100 hacks |

### User Trust Indicators

1. **"Detected before audit"** - Track findings that match later audit reports
2. **"Rules updated within 48h"** - New rules for major hacks
3. **"Community contributions"** - External rule submissions
4. **"Zero false negatives"** - No missed CTF challenges

---

## File Structure

```
scanner/
├── rules/
│   ├── solidity.yaml           # Core Solidity rules (existing)
│   ├── defi-advanced.yaml      # NEW: DeFi protocol patterns
│   ├── vyper.yaml              # NEW: Vyper language rules
│   ├── security-hints.yaml     # NEW: Guidance/recommendations
│   ├── erc-standards.yaml      # NEW: ERC compliance rules
│   └── invariants.yaml         # NEW: Suggested invariants
├── scan.py                     # Main scanner (enhance fuzzing)
└── templates/
    └── fuzz/                   # NEW: Fuzz test templates
        ├── erc20.t.sol
        ├── vault.t.sol
        └── amm.t.sol
```

---

## Quick Wins (This Week)

1. **Create `defi-advanced.yaml`** - 50 rules from real exploits
2. **Add DeFiHackLabs to benchmark** - 300+ exploit PoCs
3. **Implement "missing fuzz" detection** - Easy, high value
4. **ERC4626 vault rules** - Hot standard, known issues

---

## Long-term Vision

```
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║   "The scanner that caught the $100M bug before the hackers did"        ║
║                                                                          ║
║   • 300+ Solidity rules from real exploits                              ║
║   • 50+ Vyper rules for Curve/Yearn ecosystem                           ║
║   • Fuzzing integration for semantic bugs                                ║
║   • Security hints for vibe coders                                       ║
║   • Rules updated within 48h of major hacks                             ║
║   • Open source rule contributions                                       ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

*Created: 2026-01-07*
*Last Updated: 2026-01-07*
*Status: Planning → Implementation*
