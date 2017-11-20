// Yoichi's simple wallet contract proofs
// ======================================

module SIMPLEWALLET-SPEC
imports ETHEREUM-SIMULATION



    rule <k> #execute ... </k>
//         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

//         <output>        .WordStack </output>
//         <memoryUsed>    MEM          </memoryUsed>
//         <callDepth>     CD          </callDepth>
//         <callStack>     .List      </callStack>
//         <interimStates> .List      </interimStates>
//         <substateStack> .List      </substateStack>
//         <callLog>       .Set       </callLog>

         <program>      %SimpleWallet          </program>
         <programBytes> %SimpleWalletBytes     </programBytes>
         <id>           %WALLET_ID              </id>
         <caller>       %OWNER_ID            </caller>
//         <callData>     .WordStack            </callData>
         <callValue>    0                     </callValue>
         <wordStack>    WS   => 0 : WS </wordStack>
//         <localMem>     LM => LM1        </localMem>
         <pc>           0  => 2          </pc>
//         <gas>          1000000    => _    </gas>
//         <previousGas>  _    => _             </previousGas>

//         <selfDestruct> .Set   </selfDestruct>
//         <log>          .List  </log>
//         <refund>       _ => _ </refund>

//         <gasPrice>     _               </gasPrice>
//         <origin>       %OWNER_ID      </origin>
//         <gasLimit>     _               </gasLimit>
//         <coinbase>     CB </coinbase>
//         <timestamp>    TS               </timestamp>
//         <number>       NUM               </number>
//         <previousHash> PH               </previousHash>
//         <difficulty>   DIFF             </difficulty>

         <activeAccounts> %WALLET_ID |-> false
                          %OWNER_ID  |-> true
         </activeAccounts>
         <accounts>
           <account>
             <acctID>  %WALLET_ID          </acctID>
             <balance> %WALLET_BALANCE    </balance>
             <code>    %SimpleWalletBytes </code>
             <nonce>   0                 </nonce>
             <storage> 0 |-> %OWNER_ID   </storage>
           </account>
           <account>
            <acctID>  %OWNER_ID          </acctID>
             <balance> 0               </balance>
             <code>    .WordStack </code>
             <nonce>   0                 </nonce>
             <storage> .Map             </storage>
           </account>
         </accounts>

      requires #sizeWordStack(WS) <Int 1017
endmodule
