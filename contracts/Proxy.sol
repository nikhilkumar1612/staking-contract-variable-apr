// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.17;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract ProxyContract is TransparentUpgradeableProxy {
    
    constructor(
        address _impl,
        address _owner,
        bytes memory _data
    ) TransparentUpgradeableProxy(_impl, _owner, _data) {}
}