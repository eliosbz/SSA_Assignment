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
    uint tax_allowance;

    uint income;

    constructor(address p1, address p2) {
        age = 0;
        isMarried = false;
        parent1 = p1;
        parent2 = p2;
        spouse = address(0);
        income = 0;
        tax_allowance = DEFAULT_ALLOWANCE;
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

        if (spouse_tp.getSpouse() != address(this)) {
            spouse_tp.marry(address(this));
        }
    }
    
    function divorce() public {
        Taxpayer spouse_tp = Taxpayer(address(spouse));

        require(isMarried && spouse != address(0));

        spouse = address(0);
        isMarried = false;
        tax_allowance = DEFAULT_ALLOWANCE;

        if (spouse_tp.getIsMarried()) {
            spouse_tp.divorce();
        }
    }
    
    /* Transfer part of tax allowance to own spouse */
    function transferAllowance(uint change) public {
        require(isMarried);
        require(change <= tax_allowance);
        
        tax_allowance -= change;
        Taxpayer sp = Taxpayer(address(spouse));
        sp.setTaxAllowance(sp.getTaxAllowance() + change);
    }

    function getAge() public view returns (uint) {
        return age;
    }

    function haveBirthday() public {
        age++;
    }
    
    function getIsMarried() public view returns (bool) {
        return isMarried;
    }

    function getSpouse() public view returns (address) {
        return spouse;
    }

    function setTaxAllowance(uint ta) public {
        tax_allowance = ta;
    }

    function getTaxAllowance() public view returns (uint) {
        return tax_allowance;
    }
}
