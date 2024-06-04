pragma solidity ^0.8.22;

contract Taxpayer {
    uint age;

    bool isMarried;

    /* Reference to spouse if person is married, address(0) otherwise */
    address spouse;

    address parent1;
    address parent2;

    /* Constant default income tax allowance */
    uint constant DEFAULT_ALLOWANCE = 5000;

    /* Constant income tax allowance for Older Taxpayers over 65 */
    uint constant ALLOWANCE_OAP = 7000;

    /* Income tax allowance */
    uint single_tax_allowance;
    uint married_tax_allowance;

    uint income;

    constructor(address p1, address p2) {
        age = 0;
        isMarried = false;
        parent1 = p1;
        parent2 = p2;
        spouse = address(0);
        income = 0;
        single_tax_allowance = DEFAULT_ALLOWANCE;
        married_tax_allowance = 0;
    }

    //We require new_spouse != address(0);
    function marry(address new_spouse) public {
        Taxpayer spouse_tp = Taxpayer(new_spouse);
        
        require(new_spouse != address(0));
        require(new_spouse != parent1 && new_spouse != parent2);
        require(new_spouse != address(this));
        require(age >= 18);
        require(!isMarried && spouse == address(0));
        require(!spouse_tp.getIsMarried() && spouse_tp.getSpouse() == address(0));
        
        spouse = new_spouse;
        isMarried = true;
        married_tax_allowance = single_tax_allowance;

        if (spouse_tp.getSpouse() != address(this)) {
            spouse_tp.marry(address(this));
        }
    }
    
    function divorce() public {
        Taxpayer spouse_tp = Taxpayer(address(spouse));

        require(isMarried && spouse != address(0));

        spouse = address(0);
        isMarried = false;
        married_tax_allowance = 0;

        if (spouse_tp.getIsMarried()) {
            spouse_tp.divorce();
        }
    }
    
    /* Transfer part of tax allowance to own spouse */
    function transferAllowance(uint change) public {
        require(change > 0);
        require(isMarried);
        require(change <= married_tax_allowance);
        
        married_tax_allowance -= change;
        Taxpayer sp = Taxpayer(address(spouse));
        sp.setTaxAllowance(sp.getTaxAllowance() + change);
    }

    function getAge() public view returns (uint) {
        return age;
    }

    function haveBirthday() public {
        age++;

        if (age == 65 && single_tax_allowance == DEFAULT_ALLOWANCE) {
            single_tax_allowance = ALLOWANCE_OAP;

            if (isMarried) {
                married_tax_allowance += (ALLOWANCE_OAP - DEFAULT_ALLOWANCE);
            }
        }
    }
    
    function getIsMarried() public view returns (bool) {
        return isMarried;
    }

    function getSpouse() public view returns (address) {
        return spouse;
    }

    function setTaxAllowance(uint ta) public {
        if (isMarried) {
            if (ta >= single_tax_allowance) {
                married_tax_allowance += (ta - single_tax_allowance);
            } else {
                require((single_tax_allowance - ta) <= married_tax_allowance);
                married_tax_allowance -= (single_tax_allowance - ta);
            }
        }

        single_tax_allowance = ta;
    }

    function getTaxAllowance() public view returns (uint) {
        if (isMarried) {
            return married_tax_allowance;
        }

        return single_tax_allowance;
    }

    function setIncome(uint new_income) public {
        income = new_income;
    }

    function getIncome() public view returns (uint) {
        return income;
    }

    function getTaxesToPay(uint percentage) public view returns (uint) {
        require(percentage <= 100);
        uint taxesAmount = 0;

        if (income > getTaxAllowance()) {
            uint taxableIncome = income - getTaxAllowance();
            taxesAmount = (taxableIncome / 100) * percentage;
        }

        return taxesAmount;
    }
}
