// Yoichi's simple wallet contract proofs
// ======================================

module SIMPLEWALLET-SPEC
imports ETHEREUM-SIMULATION

    rule <k> #execute ... </k>
         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

         <output>        .WordStack </output>
         <memoryUsed>    3          </memoryUsed>
         <callDepth>     0          </callDepth>
         <callStack>     .List      </callStack>
         <interimStates> .List      </interimStates>
         <substateStack> .List      </substateStack>
         <callLog>       .Set       </callLog>

         <program>      %SimpleWallet         </program>
         <programBytes> %SimpleWalletBytes    </programBytes>
         <id>           %ACCT_ID              </id>
         <caller>       %CALLER_ID            </caller>
         <callData>     .WordStack            </callData>
         <callValue>    0                     </callValue>
         <wordStack>    WS   => 9040:%CALLER_ID:BAL:0:0:0:0:WS </wordStack>
         <localMem>     .Map => ?B:Map        </localMem>
         <pc>           0    => 21            </pc>
         <gas>          G    => G1            </gas>
         <previousGas>  _    => _             </previousGas>

         <selfDestruct> .Set   </selfDestruct>
         <log>          .List  </log>
         <refund>       0 => _ </refund>

         <gasPrice>     _               </gasPrice>
         <origin>       %ORIGIN_ID      </origin>
         <gasLimit>     _               </gasLimit>
         <coinbase>     %COINBASE_VALUE </coinbase>
         <timestamp>    1               </timestamp>
         <number>       0               </number>
         <previousHash> 0               </previousHash>
         <difficulty>   256             </difficulty>

         <activeAccounts> %ACCT_ID   |-> false
                          %CALLER_ID |-> true </activeAccounts>
         <accounts>
           <account>
             <acctID>  %ACCT_ID           </acctID>
             <balance> BAL => _           </balance>
             <code>    %SimpleWalletBytes </code>
             <nonce>   0                  </nonce>
             <storage> 0 |-> %CALLER_ID
             </storage>
           </account>
           <account>
             <acctID>  %CALLER_ID         </acctID>
             <balance> 0                  </balance>
             <code>    .WordStack         </code>
             <nonce>   0                  </nonce>
             <storage> .Map               </storage>
           </account>
         </accounts>

      requires G >=Int 1000000  andBool #sizeWordStack(WS) <Int 1017
endmodule
