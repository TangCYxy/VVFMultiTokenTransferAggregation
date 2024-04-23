# allow multi gasless token transfer in one single transaction
- allow anyone to do multi token transfer in one single transaction with gasless transfer function supported by usdc or usdt.

## installation
- nvm use 16.14.0
- cd code
- npm install
- mv truffle-config.js.example truffle-config.js
- truffle compile
- truffle migrate
## note
- if one transfer reverted then all of the other token transfer in the same transaction will be revert