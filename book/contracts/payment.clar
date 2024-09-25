(define-fungible-token my-token uint)

;; Define the administrator (contract deployer)
(define-constant administrator tx-sender)

;; Define an event to track token transfers
(define-event transfer-event
  (sender principal) (recipient principal) (amount uint))

;; Mint new tokens and send them to a recipient
(define-public (mint-tokens (recipient principal) (amount uint))
  (begin
    ;; Ensure only the administrator can mint tokens
    (asserts! (is-eq tx-sender administrator) (err "Only administrator can mint tokens"))
    
    ;; Mint the specified amount of tokens to the recipient
    (ft-mint? my-token amount recipient)
    
    ;; Emit the transfer event
    (print (transfer-event administrator recipient amount))
    
    ;; Return a success response
    (ok amount)
  )
)

;; Transfer tokens from the sender to the recipient
(define-public (transfer (recipient principal) (amount uint))
  (begin
    ;; Transfer the tokens from tx-sender to the recipient
    (ft-transfer? my-token amount tx-sender recipient)
    
    ;; Emit the transfer event
    (print (transfer-event tx-sender recipient amount))
    
    ;; Return a success response
    (ok amount)
  )
)

;; Check the balance of a given principal
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance my-token account))
)
