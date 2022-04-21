-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Ethereum Blockchain Data Analysis - <a href=https://github.com/blockchain-etl/ethereum-etl-airflow/tree/master/dags/resources/stages/raw/schemas>Table Schemas</a>
-- MAGIC - **Transactions** - Each block in the blockchain is composed of zero or more transactions. Each transaction has a source address, a target address, an amount of Ether transferred, and an array of input bytes. This table contains a set of all transactions from all blocks, and contains a block identifier to get associated block-specific information associated with each transaction.
-- MAGIC - **Blocks** - The Ethereum blockchain is composed of a series of blocks. This table contains a set of all blocks in the blockchain and their attributes.
-- MAGIC - **Receipts** - the cost of gas for specific transactions.
-- MAGIC - **Traces** - The trace module is for getting a deeper insight into transaction processing. Traces exported using <a href=https://openethereum.github.io/JSONRPC-trace-module.html>Parity trace module</a>
-- MAGIC - **Tokens** - Token data including contract address and symbol information.
-- MAGIC - **Token Transfers** - The most popular type of transaction on the Ethereum blockchain invokes a contract of type ERC20 to perform a transfer operation, moving some number of tokens from one 20-byte address to another 20-byte address. This table contains the subset of those transactions and has further processed and denormalized the data to make it easier to consume for analysis of token transfer events.
-- MAGIC - **Contracts** - Some transactions create smart contracts from their input bytes, and this smart contract is stored at a particular 20-byte address. This table contains a subset of Ethereum addresses that contain contract byte-code, as well as some basic analysis of that byte-code. 
-- MAGIC - **Logs** - Similar to the token_transfers table, the logs table contains data for smart contract events. However, it contains all log data, not only ERC20 token transfers. This table is generally useful for reporting on any logged event type on the Ethereum blockchain.
-- MAGIC 
-- MAGIC ### Rubric for this module
-- MAGIC Answer the quetions listed below.

-- COMMAND ----------

-- MAGIC %run ./includes/utilities

-- COMMAND ----------

-- MAGIC %run ./includes/configuration

-- COMMAND ----------

use ethereumetl;
show tables;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q1: What is the maximum block number and date of block in the database

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q2: At what block did the first ERC20 transfer happen?

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q3: How many ERC20 compatible contracts are there on the blockchain?

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC ## Q4: What percentage of transactions are calls to contracts

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q5: What are the top 100 tokens based on transfer count?

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q6: What fraction of ERC-20 transfers are sent to new addresses
-- MAGIC (i.e. addresses that have a transfer count of 1 meaning there are no other transfers to this address for this token this is the first)

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q7: In what order are transactions included in a block in relation to their gas price?
-- MAGIC - hint: find a block with multiple transactions 

-- COMMAND ----------

-- MAGIC %python
-- MAGIC transaction = spark.sql("select * from ethereumetl.transactions")
-- MAGIC display(transaction)
-- MAGIC display(transaction.filter("block_number == 3300360"))

-- COMMAND ----------

-- MAGIC %md
-- MAGIC It looks like the transaction is ordered by the gas_price in a descending ordering 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q8: What was the highest transaction throughput in transactions per second?
-- MAGIC hint: assume 15 second block time

-- COMMAND ----------

-- MAGIC %python
-- MAGIC transaction = spark.sql("select * from ethereumetl.transactions")
-- MAGIC rate = transaction.groupBy("block_number").count()
-- MAGIC display(rate)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC from pyspark.sql.functions import  desc
-- MAGIC rate = rate.sort(desc("count"))
-- MAGIC display(rate)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC since the highest transaction block has transaction 1415, then the highest transaction per second is 94.33  

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q9: What is the total Ether volume?
-- MAGIC Note: 1x10^18 wei to 1 eth and value in the transaction table is in wei

-- COMMAND ----------

-- MAGIC %python
-- MAGIC 
-- MAGIC transaction = spark.sql("select * from ethereumetl.transactions")
-- MAGIC display(transaction)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC from pyspark.sql.functions import  sum
-- MAGIC total_value = transaction.select(sum('value')/(10**18)).collect()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC total_value[0]

-- COMMAND ----------

-- MAGIC %md
-- MAGIC the total Ether volume is 4819303728.848482

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q10: What is the total gas used in all transactions?

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q11: Maximum ERC-20 transfers in a single transaction

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q12: Token balance for any address on any date?

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q13 Viz the transaction count over time (network use)

-- COMMAND ----------

-- TBD

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Q14 Viz ERC-20 transfer count over time
-- MAGIC interesting note: https://blog.ins.world/insp-ins-promo-token-mixup-clarified-d67ef20876a3

-- COMMAND ----------

-- TBD


-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Return Success
-- MAGIC dbutils.notebook.exit(json.dumps({"exit_code": "OK"}))
