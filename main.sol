pragma solidity ^0.5.17;

contract StructDemo{ 
uint public orderid;
struct Order{ 
	uint id;
	uint quantity; 
	uint price;
	bool paid;
} 


Order []orders; 
event Accepted(address, uint, uint );
event Paid(address, uint);
mapping(uint => address)public worder;

function addOrder(uint q) public{
    orderid++;
    Order memory t = Order(orderid, q, q*250, false);
    orders.push(t);
    worder[orderid] = msg.sender;
    
}
    
function getOrderIds() public view returns(uint[] memory) {
    uint i;
    uint a = orders.length;
    uint[] memory temp = new uint[](a);
    for(i = 0; i<orders.length; i++){
        Order memory t = orders[i];
        temp[i] = t.id;
    }
    return(temp);
}


function acceptOrder(uint aid) public returns(uint, uint){
   require(msg.sender != worder[aid]);
   uint i; 
	for(i=0;i<orders.length;i++) 
	{ 
		Order memory t = orders[i]; 
		if(t.id==aid) 
		{ 
		    require(t.paid == true);
		    emit Accepted(msg.sender, t.id, t.price);
		    require (i < orders.length);
		    orders[i] = orders[orders.length-1];
		    delete orders[orders.length-1];
		    orders.length--;
			return(t.id, t.price);
		} 
	} 
	return(0, 0); 
   
}

function payForOrder(uint aid) public{
    require(msg.sender == worder[aid]);
    uint i;
    for(i=0; i<orders.length; i++){
        Order memory t = orders[i];
        if(t.id == aid){
            orders[i].paid = true;
            emit Paid(msg.sender, t.price);
        }
    }
}
}
