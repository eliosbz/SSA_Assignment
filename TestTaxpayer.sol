pragma solidity ^0.8.22;

import "./Taxpayer.sol";

contract TestTaxpayer is Taxpayer(address(1), address(2)) {
    constructor() {}

    function echidna_test_marry_bidirectional() public returns (bool) {
        if (isMarried) {
            return Taxpayer(spouse).getIsMarried() && Taxpayer(spouse).getSpouse() == address(this);
        }

        return true;
    }

    function echidna_test_marry_address0() public returns (bool) {
        return (isMarried && spouse != address(0)) || (!isMarried && spouse == address(0));
    }
    
    function echidna_test_marry_parent() public returns (bool) {
        return spouse != parent1 && spouse != parent2;
    }

    function echidna_test_marry_itself() public returns (bool) {
        return spouse != address(this);
    }

    function echidna_test_marry_underage() public returns (bool) {
        if (isMarried) {
            return age >= 18;
        }

        return true;
    }
}
