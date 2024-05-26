pragma solidity ^0.8.22;

import "./Taxpayer.sol";

contract TestTaxpayer is Taxpayer(address(1), address(2)) {
    constructor() {}

    // PART 1

    function echidna_test_marry_bidirectional() public view returns (bool) {
        if (isMarried) {
            return Taxpayer(spouse).getIsMarried() && Taxpayer(spouse).getSpouse() == address(this);
        }

        return true;
    }

    function echidna_test_marry_address0() public view returns (bool) {
        return (isMarried && spouse != address(0)) || (!isMarried && spouse == address(0));
    }
    
    function echidna_test_marry_parent() public view returns (bool) {
        return spouse != parent1 && spouse != parent2;
    }

    function echidna_test_marry_itself() public view returns (bool) {
        return spouse != address(this);
    }

    function echidna_test_marry_underage() public view returns (bool) {
        if (isMarried) {
            return age >= 18;
        }

        return true;
    }

    // PART 2

    function getPseudoRandom() private view returns (uint) {
        return uint(keccak256(abi.encode(block.timestamp, block.difficulty))) % 20000;
    }

    function echidna_test_tax_allowance() public returns (bool) {
        if (isMarried) {
            Taxpayer spouse_tp = Taxpayer(spouse);
            uint sum_before_transfer = tax_allowance + spouse_tp.getTaxAllowance();

            transferAllowance(getPseudoRandom());

            uint sum_after_transfer = tax_allowance + spouse_tp.getTaxAllowance();
            return (sum_before_transfer == sum_after_transfer) && tax_allowance > 0 && spouse_tp.getTaxAllowance() > 0;
        }

        return tax_allowance > 0;
    }
}
