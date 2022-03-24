# web3_learning_tutorials

Implementation of ethereum smart contract read/write by web3.py and flask.

### Used library and plugins
-	Solidity
-	Web3.py
-	Flask
- Brownie
- Ganache

### How to build code
its required latest node and npm installed on local machine. this build work on any OS which support node and npm.
install dependency by using command npm install in root folder. 

### How to Run
Update .env file with below field
-	export EMPLOYEE_SOL_FILE_PATH = "PATH to web3_learning_tutorials/reward_system/contracts/employee_contract.sol"
-	export GANACHE_CONN = "http://127.0.0.1:<ganache_port>"
-	export MY_ADDRESS = <account_address>
-	export MY_PRIVATE_KEY = <private_key>
-	export CHAIN_ID = <ganache_chain_id>

Run flask_server.py file using command 
<h5>python3 reward_system_web3/flask_server.py</h5>

flask_server.py will compile code and deploye employee_contract.sol file on ganache.
use url to view UI in browser http://localhost:5058

### Flask API
- http://localhost:5058/GetEmployeeData/<id>
- http://localhost:5058/GetAllEmployeeData
- http://localhost:5058/AddEmployeeData
	<br>json payload : {"name":"John", "designation":"Engineer", "reward_amount":500}
	<br>reward_amount field is completely mendatory (default reward_amount : 1000)
- http://localhost:5058/UpdateEmployeeData
	<br>json payload : {"id":0, "name":"John Pater", "designation":"Engineer"}
  <br>Update employee data will update only name OR designation.
