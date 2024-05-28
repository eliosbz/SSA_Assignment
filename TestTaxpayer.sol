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
    /*
    function getPseudoRandom() private view returns (uint) {
        return uint(keccak256(abi.encode(block.timestamp, block.difficulty))) % 100000;
    }

	
    function echidna_test_tax_allowance() public returns (bool) {
        if (isMarried) {
            Taxpayer spouse_tp = Taxpayer(spouse);
            uint sum_before_transfer = tax_allowance + spouse_tp.getTaxAllowance();

            transferAllowance(100000);

            uint sum_after_transfer = tax_allowance + spouse_tp.getTaxAllowance();
            return (sum_before_transfer == sum_after_transfer);//&& tax_allowance > 1000 && spouse_tp.getTaxAllowance() > 1000;
			
        }

        return true; //tax_allowance > 1000;
    }
	*/

	function check_allowance_transfer(uint change) public {
		uint old_allowance;
		uint new_allowance;

		if (isMarried) {
			Taxpayer spouse = Taxpayer(getSpouse());
			old_allowance = tax_allowance + spouse.getTaxAllowance();
            transferAllowance(change);
            new_allowance = tax_allowance + spouse.getTaxAllowance();
		} else {
            old_allowance = tax_allowance;
            transferAllowance(change);
            new_allowance = tax_allowance;
        }

		assert(old_allowance == new_allowance);
	}
}
