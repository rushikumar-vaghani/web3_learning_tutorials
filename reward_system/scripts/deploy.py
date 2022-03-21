from brownie import Employees, accounts

def main():
        acct = accounts.load('deployment_account')
        Employees.deploy({'from': acct})
