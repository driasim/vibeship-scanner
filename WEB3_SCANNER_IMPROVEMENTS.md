# Web3 Scanner Improvements Backlog

This document tracks edge cases, gaps, and improvements that require tools **beyond pure SAST** (Static Application Security Testing). These are findings from benchmark testing where pattern-based detection hits its limits.

---

## Categories

| Category | Tool/Approach | Use Case |
|----------|---------------|----------|
| **Custom Slither Detectors** | Python detectors using Slither's IR | Cross-function dataflow, semantic analysis |
| **Fuzzing** | Echidna, Foundry Fuzz | Invariant violations, edge case inputs |
| **Symbolic Execution** | Mythril, Halmos | Path exploration, constraint solving |
| **Formal Verification** | Certora, Halmos | Mathematical proofs of correctness |
| **Runtime Analysis** | Forta, Tenderly | Live transaction monitoring |

---

## Custom Slither Detectors Needed

### 1. Cross-Function Reentrancy Guard Release (HIGH PRIORITY)

**Source**: OnlyPwner - 13th-airdrop
**Current Coverage**: Partial (flags suspicious patterns, not exact vulnerability)

**The Gap**:
```solidity
function claim() external nonReentrant {
    // ... external call ...
    entered = false;           // Guard released
    updateUserBalance();       // State change in assembly (separate function)
}

function updateUserBalance() internal {
    assembly {
        sstore(slot, newValue)  // Actual state change hidden here
    }
}
```

**Why SAST Can't Catch It**:
- CEI violation spans multiple functions
- Assembly obfuscates the state change
- Need to track: guard release → function call → contains sstore

**Detector Requirements**:
1. Identify reentrancy guard variables (`entered`, `_status`, etc.)
2. Track when guard is set to "unlocked" state
3. Find subsequent function calls before next external interaction
4. Flag if those functions contain `sstore` operations

**Effort**: Medium (~2-3 hours)

---

### 2. Storage Collision in Unstructured Storage Patterns

**Source**: General upgradeable contract audits
**Current Coverage**: Basic slot detection only

**The Gap**:
```solidity
// Contract A uses slot keccak256("eip1967.proxy.implementation")
// Contract B accidentally uses same slot for different purpose
bytes32 constant SLOT = keccak256("eip1967.proxy.implementation");
```

**Why SAST Can't Catch It**:
- Need to compute actual keccak256 values
- Compare across multiple contracts in inheritance chain
- Understand EIP-1967 standard slots

**Detector Requirements**:
1. Extract all storage slot definitions
2. Compute actual slot values (resolve keccak256)
3. Compare across contract inheritance
4. Flag collisions with standard EIP slots

**Effort**: Medium (~3-4 hours)

---

### 3. Phantom Function Detection (Proxy Selector Collision)

**Source**: General proxy audits
**Current Coverage**: None

**The Gap**:
```solidity
// Proxy has function with selector 0x12345678
// Implementation has different function with same selector
// Calls to implementation get intercepted by proxy
```

**Why SAST Can't Catch It**:
- Need to compute function selectors (first 4 bytes of keccak256)
- Compare across proxy and implementation contracts
- Understand delegatecall routing

**Detector Requirements**:
1. Extract all function selectors from proxy
2. Extract all function selectors from implementation
3. Flag any collisions
4. Special attention to common selectors (upgrade, admin, etc.)

**Effort**: Medium (~2-3 hours)

---

### 4. Incorrect Inheritance Order (C3 Linearization Issues)

**Source**: Complex multi-inheritance contracts
**Current Coverage**: None

**The Gap**:
```solidity
// Wrong order can cause unexpected function resolution
contract Bad is A, B { }  // B.foo() called
contract Good is B, A { } // A.foo() called
```

**Why SAST Can't Catch It**:
- Need to understand Solidity's C3 linearization
- Track function overrides across inheritance chain
- Identify when order affects behavior

**Effort**: High (~4-5 hours)

---

## Fuzzing Improvements Needed

### 1. Invariant Test Generation

**Source**: General DeFi protocols
**Current Coverage**: Detects missing fuzz tests only

**The Gap**:
- We detect contracts WITHOUT fuzz tests
- But can't auto-generate meaningful invariants

**Improvement Ideas**:
1. Auto-generate basic invariants from common patterns:
   - `totalSupply == sum(balances)`
   - `address(this).balance >= totalDeposits`
   - `reserves[0] * reserves[1] >= k` (AMM)
2. Template-based invariant suggestions
3. Integration with Foundry's invariant testing

**Effort**: High (~1-2 days)

---

### 2. Economic Attack Simulation

**Source**: DeFi exploit post-mortems
**Current Coverage**: None (beyond basic patterns)

**The Gap**:
- Flash loan attack vectors
- Price manipulation sequences
- MEV extraction opportunities

**Why Fuzzing Helps**:
- Can simulate multi-step attack sequences
- Test with extreme values (flash loan amounts)
- Find profitable attack paths

**Effort**: Very High (ongoing research)

---

## Symbolic Execution Gaps

### 1. Deep Path Exploration Timeout

**Source**: Complex contracts (100+ functions)
**Current Coverage**: Limited to 5 files due to timeout

**The Gap**:
- Mythril times out on large contracts
- Miss vulnerabilities in complex code paths

**Improvements Needed**:
1. Smarter file selection (prioritize risky patterns)
2. Incremental analysis (cache previous runs)
3. Parallel execution across files

**Effort**: Medium (~1 day)

---

### 2. Cross-Contract Symbolic Analysis

**Source**: Multi-contract protocols
**Current Coverage**: Single contract only

**The Gap**:
```solidity
// Vulnerability requires understanding both contracts
contract Vault {
    function withdraw() { token.transfer(...); }
}
contract Token {
    function transfer() { /* malicious callback */ }
}
```

**Improvements Needed**:
1. Build cross-contract call graph
2. Symbolic execution across contract boundaries
3. Model external contract behavior

**Effort**: Very High (research-level)

---

## Formal Verification Opportunities

### 1. AMM Invariant Proofs

**Source**: DEX protocols
**Current Coverage**: None

**Opportunity**:
- Prove `x * y = k` holds after all operations
- Prove no value extraction possible
- Prove LP token accounting correctness

**Tool**: Certora or Halmos

**Effort**: High per protocol

---

### 2. Access Control Completeness

**Source**: All admin-controlled contracts
**Current Coverage**: Pattern-based only

**Opportunity**:
- Prove all admin functions have proper checks
- Prove no unauthorized state changes possible
- Prove upgrade safety

**Effort**: Medium per contract

---

## Runtime/Dynamic Analysis Needs

### 1. Live Mempool Monitoring

**Source**: MEV protection
**Current Coverage**: None (static only)

**The Gap**:
- Sandwich attack detection
- Frontrunning vulnerability
- Transaction ordering dependence

**Tool**: Forta agents, Flashbots Protect integration

---

### 2. Post-Deployment Monitoring

**Source**: All deployed contracts
**Current Coverage**: Pre-deployment only

**Opportunity**:
- Track actual usage patterns
- Detect anomalous transactions
- Alert on exploit attempts

**Tool**: Tenderly, Forta, custom monitoring

---

## Benchmark-Specific Gaps

### OnlyPwner (17 challenges)
| Challenge | Gap Type | Tool Needed | Status |
|-----------|----------|-------------|--------|
| 13th-airdrop | Cross-function CEI | Custom Slither | Documented |

### DeFiVulnLabs (50+ tests)
| Test | Gap Type | Tool Needed | Status |
|------|----------|-------------|--------|
| TBD | TBD | TBD | Pending benchmark |

### Damn Vulnerable DeFi (18 challenges)
| Challenge | Gap Type | Tool Needed | Status |
|-----------|----------|-------------|--------|
| TBD | TBD | TBD | Pending benchmark |

### Ethernaut (30+ levels)
| Level | Gap Type | Tool Needed | Status |
|-------|----------|-------------|--------|
| TBD | TBD | TBD | Pending benchmark |

---

## Priority Queue

### Immediate (Before v1.0)
1. [ ] Custom Slither: Cross-function reentrancy guard
2. [ ] Improve Mythril file selection strategy

### Short-term (v1.1)
3. [ ] Custom Slither: Storage collision detection
4. [ ] Custom Slither: Phantom function detection
5. [ ] Fuzzing: Basic invariant templates

### Medium-term (v1.2+)
6. [ ] Symbolic: Cross-contract analysis
7. [ ] Formal: AMM invariant proofs
8. [ ] Runtime: Forta agent integration

---

## How to Add New Entries

When benchmarking reveals a gap that SAST can't cover:

1. **Identify the category** (Slither/Fuzzing/Symbolic/Formal/Runtime)
2. **Document the gap**:
   - Source benchmark and challenge name
   - Code example showing the vulnerability
   - Why SAST can't detect it
   - What tool/approach would work
3. **Estimate effort** (Low/Medium/High/Very High)
4. **Add to appropriate section** above
5. **Update Priority Queue** if high-impact

---

## References

- [Slither Detector Documentation](https://github.com/crytic/slither/wiki/Detector-Documentation)
- [Echidna Tutorial](https://github.com/crytic/echidna)
- [Mythril Documentation](https://mythril-classic.readthedocs.io/)
- [Certora Prover](https://docs.certora.com/)
- [Forta Network](https://forta.org/)

---

*Last Updated: 2026-01-08*
*Maintained by: Vibeship Scanner Team*
