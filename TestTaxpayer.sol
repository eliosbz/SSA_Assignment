pragma solidity ^0.8.22;

import "./Taxpayer.sol";

contract TestTaxpayer is Taxpayer(address(1), address(2)) {
    Taxpayer test_spouse;

    constructor() {
        test_spouse = new Taxpayer(address(100), address(200));

        for (uint i = 0; i < 30; i++) {
            haveBirthday();
            test_spouse.haveBirthday();
        }
    }

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
			old_allowance = married_tax_allowance + spouse.getTaxAllowance();
            transferAllowance(change);
            new_allowance = married_tax_allowance + spouse.getTaxAllowance();
		} else {
            old_allowance = single_tax_allowance;
            transferAllowance(change);
            new_allowance = single_tax_allowance;
        }

		assert(old_allowance == new_allowance);
	}

    function check_allowance_set(uint ta) public {
        if (isMarried) {
            uint old_married_tax_allowance = married_tax_allowance;
            setTaxAllowance(ta);
            uint new_married_tax_allowance = married_tax_allowance;
            
            if (ta >= single_tax_allowance) {
                assert(new_married_tax_allowance == old_married_tax_allowance + (ta - single_tax_allowance));
            } else {
                assert(new_married_tax_allowance == old_married_tax_allowance - (single_tax_allowance - ta));
            }
        } else {
            setTaxAllowance(ta);
        }
        
        assert(single_tax_allowance == ta);
    }

    // Extras

    function check_taxes_get(uint percentage) public view {
        if (income > getTaxAllowance()) {
            uint taxes = getTaxesToPay(percentage);
            assert(taxes <= (income - getTaxAllowance()));
        }
    }
}
