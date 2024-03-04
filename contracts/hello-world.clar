;; Community Hello World
;; A contract that provides a simple community board but can only be updated once the admin gives permission

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Cons, Variables and Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Error messages
(define-constant ERR-NOT-NEXT-USER (err u0))
(define-constant ERR-NOT-FILLED (err u1))
(define-constant ERR-NOT-ADMIN (err u2))
(define-constant ERR-ADMIN-CANNOT-UPDATE (err u3))
(define-constant ERR-CURRENT-USER-CANNOT-UPDATE (err u4))

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

;; Get community billboard
(define-read-only (get-community-board) 
    (var-get billboard)
)

;; Get next user
(define-read-only (get-next-user) 
    (var-get next-user)
)

;;;;;;;;;;;;;;;;;;;;;;;
;;; Public functions ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Update billboard
;; @desc: function used by next user to update the community billboard
;; params: user-name

(define-public (update-billboard (updated-name (string-ascii 24)))
    
    (begin  
    
        ;; Asserts that tx-sender is next-user
        (asserts! (is-eq tx-sender (var-get next-user)) ERR-NOT-NEXT-USER)

        ;; Asserts that updated username is not empty
        (asserts! (not (is-eq updated-name "")) ERR-NOT-FILLED)

        ;; update the tuple by Var-set billboard 
        (ok (var-set billboard {new-user-principal: tx-sender, new-user-name: updated-name}))
    )
)

;; Admin set new user
;; @desc: function used by admin to set / give permission to the next user to update new user

(define-public (admin-set-new-user (updated-user-principal principal)) 
    (begin  
    
        ;; Asserts that tx-sender is admin
        (asserts! (is-eq tx-sender admin) ERR-NOT-ADMIN)

        ;; Assert that updated principal is NOT admin
        (asserts! (not (is-eq admin updated-user-principal)) ERR-ADMIN-CANNOT-UPDATE)

        ;; Assert that updated principal is NOT current user
        (asserts! (not (is-eq updated-user-principal (var-get next-user))) ERR-CURRENT-USER-CANNOT-UPDATE)

        ;; Var set next with updated user principal
        (ok (var-set next-user updated-user-principal))
    )
)