;; Community Hello World
;; A contract that provides a simple community board but can only be updated once the admin gives permission


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Cons, Variables and Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Deployer/admin of the contract
(define-constant admin tx-sender)

;; Variable that keeps track of the next user that gets added on to the billboard
(define-data-var next-user principal tx-sender)

;; Variable tuple that holds new members information
(define-data-var billboard {new-user-principal: principal, new-user-name: (string-ascii 24)} 
    {
        new-user-principal: tx-sender,
        new-user-name: ""
    }
)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Read-only functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;
;;; Public functions ;;
;;;;;;;;;;;;;;;;;;;;;;;
