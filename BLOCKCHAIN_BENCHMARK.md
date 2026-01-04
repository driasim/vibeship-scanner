# Blockchain/DeFi Security Benchmark - 25 Repos

## Scanning Progress Tracker

| # | Repository | Type | Status | Scan ID | Findings | Coverage |
|---|------------|------|--------|---------|----------|----------|
| 1 | [crytic/not-so-smart-contracts](https://github.com/crytic/not-so-smart-contracts) | Vuln Examples | ✅ Done | `08124dee` | 1,559 | 12/12 (100%) |
| 2 | [SunWeb3Sec/DeFiVulnLabs](https://github.com/SunWeb3Sec/DeFiVulnLabs) | 48+ Vuln Types | ✅ Done | `d5c17038` | 4,721 | 57/57 (100%) |
| 3 | [SunWeb3Sec/DeFiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs) | 674+ Real Hacks | 🔄 Scanning | `c1cf11ff` | - | - |
| 4 | [OpenZeppelin/ethernaut](https://github.com/OpenZeppelin/ethernaut) | CTF Challenges | ✅ Done | `31a42dde` | 1,688 | 31/31 (100%) |
| 5 | [theredguild/damn-vulnerable-defi](https://github.com/theredguild/damn-vulnerable-defi) | DeFi CTF | ✅ Done | - | - | 18/18 (100%) |
| 6 | [SmartContractSecurity/SWC-registry](https://github.com/SmartContractSecurity/SWC-registry) | SWC Test Cases | ⚠️ No .sol | `0eecb633` | 3 | N/A (markdown) |
| 7 | [smartbugs/smartbugs-curated](https://github.com/smartbugs/smartbugs-curated) | Annotated Dataset | ✅ Done | - | - | 143/143 (100%) |
| 8 | [Cyfrin/sc-exploits-minimized](https://github.com/Cyfrin/sc-exploits-minimized) | Minimized Exploits | 📊 Scanned | `0d0a80e5` | 706 | TBD (needs verification) |
| 9 | [sigp/solidity-security-blog](https://github.com/sigp/solidity-security-blog) | Attack Vectors | Pending | - | - | - |
| 10 | [minaminao/ctf-blockchain](https://github.com/minaminao/ctf-blockchain) | 200+ CTF | Pending | - | - | - |
| 11 | [nccgroup/GOATCasino](https://github.com/nccgroup/GOATCasino) | NCC CTF | ✅ Done | `82cd685b` | 405 | TBD |
| 12 | [razzorsec/Blockchain-HACON2020](https://github.com/razzorsec/Blockchain-HACON2020) | CTF | Pending | - | - | - |
| 13 | [paradigmxyz/paradigm-ctf-2021](https://github.com/paradigmxyz/paradigm-ctf-2021) | Paradigm CTF | ✅ Done | - | - | 15/15 (100%) |
| 14 | [pcaversaccio/reentrancy-attacks](https://github.com/pcaversaccio/reentrancy-attacks) | Reentrancy | ⚠️ Docs only | `d3215f8e` | 1 | N/A (no .sol) |
| 15 | [sirhashalot/SCV-List](https://github.com/sirhashalot/SCV-List) | Vuln List | Pending | - | - | - |
| 16 | [rajatnano/Smart-Contract-Vulnerabilities-And-Fixes](https://github.com/rajatnano/Smart-Contract-Vulnerabilities-And-Fixes) | Vuln + Fixes | Pending | - | - | - |
| 17 | [smartdec/classification](https://github.com/smartdec/classification) | Classification | Pending | - | - | - |
| 18 | [nicolasgarcia214/damn-vulnerable-defi-foundry](https://github.com/nicolasgarcia214/damn-vulnerable-defi-foundry) | DeFi Foundry | Pending | - | - | - |
| 19 | [code-423n4/2023-01-ondo](https://github.com/code-423n4/2023-01-ondo) | C4 Audit | Pending | - | - | - |
| 20 | [code-423n4/2024-04-panoptic](https://github.com/code-423n4/2024-04-panoptic) | C4 Audit | Pending | - | - | - |
| 21 | [sherlock-audit/2023-02-blueberry](https://github.com/sherlock-audit/2023-02-blueberry) | Sherlock Audit | Pending | - | - | - |
| 22 | [Cyfrin/security-and-auditing-full-course-s23](https://github.com/Cyfrin/security-and-auditing-full-course-s23) | Course | Pending | - | - | - |
| 23 | [ConsenSys/smart-contract-best-practices](https://github.com/ConsenSys/smart-contract-best-practices) | Best Practices | Pending | - | - | - |
| 24 | [OpenZeppelin/ctf-2024](https://github.com/OpenZeppelin/ctf-2024) | OZ CTF 2024 | Pending | - | - | - |
| 25 | [badbounty/dvcw](https://gitlab.com/badbounty/dvcw) | Crypto Wallet | Pending | - | - | - |

---

## Vulnerability Categories to Verify

### Critical (Must Detect)
- [ ] Reentrancy (SWC-107)
- [ ] Integer Overflow/Underflow (SWC-101) - pre-0.8
- [ ] Unchecked Return Values (SWC-104)
- [ ] Access Control Issues (SWC-105, SWC-106)
- [ ] tx.origin Authentication (SWC-115)
- [ ] Delegatecall to Untrusted Callee (SWC-112)
- [ ] Unprotected Selfdestruct (SWC-106)

### High Priority
- [ ] Flash Loan Attacks
- [ ] Price Oracle Manipulation
- [ ] Front-running (SWC-114)
- [ ] Signature Replay (SWC-121)
- [ ] Storage Collision (SWC-124)
- [ ] Uninitialized Storage Pointer (SWC-109)

### Medium Priority
- [ ] Denial of Service (SWC-113, SWC-128)
- [ ] Weak Randomness (SWC-120)
- [ ] Timestamp Dependence (SWC-116)
- [ ] Block Number Dependence
- [ ] Floating Pragma (SWC-103)
- [ ] Outdated Compiler (SWC-102)

### DeFi-Specific
- [ ] Sandwich Attacks
- [ ] Governance Attacks
- [ ] Vault Share Inflation
- [ ] First Depositor Attack
- [ ] Reward Manipulation
- [ ] Liquidation Issues

---

## Rule Improvement Log

| Date | Repo | Gap Found | Rule Created | Verified |
|------|------|-----------|--------------|----------|
| | | | | |

---

## Methodology

For each repo:
1. **SCAN**: Trigger scan via API, record scan_id
2. **DOCUMENT**: List all vulnerabilities documented in the repo
3. **GAP ANALYSIS**: Compare findings vs documented vulns
4. **WRITE RULES**: Create Opengrep rules for any gaps
5. **DEPLOY**: `fly deploy --remote-only`
6. **VERIFY**: Rescan and confirm detection with file:line evidence
7. **UPDATE**: Record in this tracking document

Coverage Formula:
```
SAST Coverage = (Detected SAST-able Vulns) / (Total SAST-able Vulns) * 100%
```

Note: Skip runtime-only vulns (CSRF, rate limiting, business logic) from coverage calculation.
