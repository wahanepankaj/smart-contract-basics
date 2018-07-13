pragma solidity ^0.4.17;

/**
 * The campaign creation factory..
 * This factory contract should be created at the time of application deployemnt 
 * and should be used to create any campaigns with the application 
 */
contract CampaignFactory {
    // Storage for all the deployed contracts by this factory
    address[] public deployedCampaigns;

    /**
     * Used to create new campaign
     */
    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    /**
     * Used to return all the compaigns that have been created by this factory
     */
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

/**
 * The actual Campaign contract
 */
contract Campaign {
    
    // Data Structure for storing spending requests
    struct Request {
        // Description for spending request
        string description;
        // Amount that needs to be spent
        uint value;
        // Address that will recieve the amount approved with this request
        address recipient;
        // Is this request finalized yet
        bool complete;
        // Total number of approvals the rquest has recieved
        uint approvalCount;
        // All the addresses that have approved this request
        mapping(address => bool) approvals;
    }

    // storage for all requests for this campaign
    Request[] public requests; 
    // the benificiary of this campaign
    address public manager; 
    // MinimumContribution amount in 'wei' to become approver
    uint public minimumContribution; 
    // Storage for approvers who have contributed t this campaign
    mapping(address => bool) public approvers; 
    // Total number of approvers who have contributed
    uint public approversCount; 

    /**
     * Constraint to be applied to some of the funtionality that can only be invoked 
     * by the manager of the campaign
     */
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    /**
     * Constructor
     * @param minimum - minimum contribution required to become an approver
     * @creator - the address that owns the contract
     */
    function Campaign(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    /**
     * The approvers can register themselves using this function by sending
     * ether to this function
     */
    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

    /**
     * This function is used to create a spending request
     * @param description - text describing this spending request
     * @param value - the amount that is requested
     * @param recipient - address that will recieve the amount approved with this request
     */
    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });

        requests.push(newRequest);
    }

    /**
     * Function used by approvers to approve a perticular request
     * @param index - the index that identifies a perticular request from the list of all requests
     */
    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    /**
     * The function used by manager to finalize or clos the request
     * end result is payment to the recipient or failure of finalization criteria
     * @param imdex - the index that identifies a perticular request from the list of all requests
     */
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    /**
     * This function can be used to retrieve summary of the instance of deployed contract
     * @return minimumContribution - the minimum contribution set for the campaign instance
     * @return balance - the remaining (or accumulated) balance for a campaign instace
     * @return requests.length - no of requests
     * @return approversCount - no of approvers that have contributed to an instance of campaign
     */
    function getSummary() public view returns (
      uint, uint, uint, uint, address
      ) {
        return (
          minimumContribution,
          this.balance,
          requests.length,
          approversCount,
          manager
        );
    }

    /**
     * @return requests.length - no of requests
     */
    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}
