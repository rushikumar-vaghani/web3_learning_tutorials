from web3 import Web3
from solcx import compile_source, install_solc, compile_standard
import json

class RewardSystem():

	def __init__(self, ganache_conn, chain_id, account, private_key, sol_file_path, sol_name):
		self.solc_version = "0.6.0"
		self.sol_file = "employee_contract.sol"
		self.sol_name = sol_name
		self.bytecode = None
		self.abicode = None
		self.chain_id = chain_id
		self.account = account
		self.private_key = private_key
		self.sol_file_path = sol_file_path
		self.w3 = Web3(Web3.HTTPProvider(ganache_conn))
		self.reward_contract = None
		print(self.w3.isConnected())

	# Read compile file code for abi
	def read_compile_source_file(self, compile_file_path):
		with open(compile_file_path, 'r') as file:
			data = json.load(file)
		return data

	# Read sol file and compile 
	def compile_sol_file(self):
		with open(self.sol_file_path, "r") as file:
			simple_storage_file = file.read()

		# Solidity source code
		compiled_sol = compile_standard({
			"language": "Solidity",
			"sources": { self.sol_file : {"content": simple_storage_file}},
			"settings": {
				"outputSelection": {
					"*": {
						"*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
					}
				}
			},
		},
		solc_version=self.solc_version)
		self.bytecode = compiled_sol["contracts"][self.sol_file][self.sol_name]["evm"]["bytecode"]["object"]
		self.abi = json.loads(compiled_sol["contracts"][self.sol_file][self.sol_name]["metadata"])["output"]["abi"]

	def build_and_sign_transaction(self, tx_hash, should_wait=True):
		# Build a transaction
		# Sign a transaction
		# Send a transaction
		nonce = self.w3.eth.getTransactionCount(self.account)
		transaction = tx_hash.buildTransaction({
				"chainId" : self.chain_id,
				"from" : self.account,
				"nonce" : nonce,
				"gasPrice": self.w3.eth.gas_price
		})
		signed_txn = self.w3.eth.account.signTransaction(transaction, private_key=self.private_key)
	
		# wait for transaction receipt once its completed.
		if (should_wait):
			tx_hash = self.w3.eth.send_raw_transaction(signed_txn.rawTransaction)
			tx_receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
			return tx_receipt

		return signed_txn
	

	# Deploye conract and get it sign using private key
	def deploye_contract(self):
		# Create contract
		contract = self.w3.eth.contract(abi=self.abi, bytecode=self.bytecode)
		tx_hash = contract.constructor()
		tx_receipt = self.build_and_sign_transaction(tx_hash)
	
		# To work with contract we need contract address and ABI
		self.reward_contract = self.w3.eth.contract(address=tx_receipt.contractAddress, abi=self.abi)
		print(f'Contract deployed to: {self.reward_contract}\n')

		return self.reward_contract

	# To add employee data 
	def add_employee_data(self, name, designation, reward_amount=None):
		if reward_amount:
			tx_hash = self.reward_contract.functions.addEmployeeData(name, reward_amount, designation)
		else:
			tx_hash = self.reward_contract.functions.addEmployeeData(name, designation)

		# buld and sign transaction by private key
		tx_receipt = self.build_and_sign_transaction(tx_hash)
		print(f'Employee data added, transcation receipt : {tx_receipt}\n')

		return tx_receipt

	# To update employee data
	def update_employee_data(self, id, name, designation):
        	tx_hash = self.reward_contract.functions.updateEmployeeData(id, name, designation)
        	# buld and sign transaction by private key
        	tx_receipt = self.build_and_sign_transaction(tx_hash)
        	print(f'Employee data updated, transcation receipt : {tx_receipt}\n')

        	return tx_receipt
