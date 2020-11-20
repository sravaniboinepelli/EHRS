// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

/// @title Contract for  managing Roles

contract Role {
    enum RoleTypes
    {
        none,
        doctor,
        patient,
        healthCareProvider  
    }
    
    mapping(address => RoleTypes) public roleMembers;


    /// @dev All the money from will be tranfered to this account.
    address payable admin = msg.sender;

   
    /// @notice Constructor initialize default values
    constructor () public {
 
    }

    /// @dev function used to set the number of players and number of dice, in addition, shuffles the dice
    /// @param account address of the doctor or patient
    /// @param role is the number of dice
    function assignRole(RoleTypes role, address account, address sender) public {

        if (role == RoleTypes.doctor) {
          require(sender == admin, "Only Admin can add doctors");
          roleMembers[account] = RoleTypes.doctor;

        }
        if (role == RoleTypes.healthCareProvider) {
          require(sender == admin, "Only Admin can add health care provider");
          roleMembers[account] = RoleTypes.healthCareProvider;

        }
        if (role == RoleTypes.patient) {
          // require(roleMembers[msg.sender] == RoleTypes.doctor, "Only admin enrolled doctors can add patients");
          roleMembers[account] = RoleTypes.patient;
        }
        
    }
    function getMemberRole(address sender) public view  returns (RoleTypes){
        require(roleMembers[sender] != RoleTypes.none, "member does not exist");
        return (roleMembers[sender]);

    }


    
}