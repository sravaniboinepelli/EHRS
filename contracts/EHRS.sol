// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

/// @title Contract for managing the Electronic Health records of patients

contract EHRS {

    uint256 numRecs = 0;

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
    string public hashValue = "none";

    struct PatientInfo {
         bool exists;
         bool patientSigned;
         uint256 recid;
         address doctor;
         string ipfsHash;
    }
    mapping(address => PatientInfo) public patientRecords;
    // mapping(address => PatientInfo) public patientPrevRecords;


    /// @dev function used to assign roles to accounts
    /// @param account address of the doctor or patient
    /// @param role is the number of dice
    function assignRole(RoleTypes role, address account) public {

        if (role == RoleTypes.doctor) {
          require(msg.sender == admin, "Only Admin can add doctors");
          roleMembers[account] = RoleTypes.doctor;

        }
        if (role == RoleTypes.healthCareProvider) {
          require(msg.sender == admin, "Only Admin can add health care provider");
          roleMembers[account] = RoleTypes.healthCareProvider;

        }
        if (role == RoleTypes.patient) {
          require(roleMembers[msg.sender] == RoleTypes.doctor, "Only admin enrolled doctors can add patients");
          roleMembers[account] = RoleTypes.patient;
        }
        
    }


    function getMemberRole(address sender) public view  returns (RoleTypes){
        require(roleMembers[sender] != RoleTypes.none, "member does not exist");
        return (roleMembers[sender]);

    }
   
    /// @notice Constructor initialize default values
    constructor ()  public {
 
    }
    function addRecord(address patient, string memory ipfsHash) public {
        RoleTypes role = getMemberRole(msg.sender);
        require(role == RoleTypes.doctor, "only doctor can add record");
        require(patientRecords[patient].exists == false, "Patient Record exist ");
        assignRole(RoleTypes.patient, patient);
        PatientInfo memory info = patientRecords[patient];
        info.exists = true;
        numRecs += 1;
        info.recid = numRecs;
        info.doctor = msg.sender;
        info.ipfsHash = ipfsHash;
        info.patientSigned = true;
        patientRecords[patient] = info;
        hashValue = ipfsHash;
    }

    function updateRecord(address patient, string memory ipfsHash) public {
        // RoleTypes role = getMemberRole();
        RoleTypes role = getMemberRole(msg.sender);
        require(role == RoleTypes.doctor, "only doctor can update record");
        role = getMemberRole(patient);
        require(role == RoleTypes.patient, "patient not in the system");
        require(patientRecords[patient].exists == true, "Patient Record does not exist ");
        PatientInfo memory info = patientRecords[patient];
        info.ipfsHash = ipfsHash;
        info.patientSigned = false;
        patientRecords[patient] = info;
    }
    function updateRecordByPatient() public {
        // RoleTypes role = getMemberRole();
        RoleTypes role = getMemberRole(msg.sender);
        require(role == RoleTypes.patient, "only patient can approve update");
        require(patientRecords[msg.sender].exists == true, "Patient Record does not exist ");
        PatientInfo memory info = patientRecords[msg.sender];
        info.patientSigned = true;
        patientRecords[msg.sender] = info;
    }

    function deleteRecord(address patient) public {
        // RoleTypes role = getMemberRole();
        RoleTypes role = getMemberRole(msg.sender);
        require(role == RoleTypes.doctor, "only doctor can delete record");
        role = getMemberRole(patient);
        require(role == RoleTypes.patient, "patient not in the system");
        require(patientRecords[patient].exists == true, "Patient Record does not exist ");
        PatientInfo memory info = patientRecords[patient];
        info.exists = false;
        patientRecords[patient] = info;
    }

    function getRecord(address patient) public view returns (string memory ipfsHash) {

        RoleTypes role = getMemberRole(msg.sender);
        require(role != RoleTypes.none, "Access denied");
        role = getMemberRole(patient);
        require(role == RoleTypes.patient, "patient not in the system");
        require(patientRecords[patient].exists == true, "Patient Record does not exist ");
        require(patientRecords[patient].patientSigned == true, "Patient Record temporarily unavailable");
        PatientInfo memory info = patientRecords[patient];
        return info.ipfsHash;   
    }
    function addDoctor(address doctor) public {
        assignRole(RoleTypes.doctor, doctor);
    }

    function addhealthCareProvider(address healthCareProvider) public {
        assignRole(RoleTypes.healthCareProvider, healthCareProvider);
    }

    

    

    
}