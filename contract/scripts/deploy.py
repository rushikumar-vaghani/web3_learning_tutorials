from brownie import testContract, accounts

def main():
	acct = accounts.load('deployment_account')
	testContract.deploy({'from': acct})

