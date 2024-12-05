.data               # start of data section
# put any global or static variables here
input_prompt:   .asciz "Enter a number (0 <= n <= 40): "
output_format:  .asciz "%ld "

.section .rodata    # start of read-only data section
# constants here, such as strings
# modifying these during runtime causes a segmentation fault, so be cautious!

.text           # start of text /code
# everything inside .text is read-only, which includes your code!
.global main  # required, tells gcc where to begin execution

# Fibonacci function to calculate F(n) iteratively
# Fibonacci function to calculate F(n) iteratively
fibonacci:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax       # F(0)
    movq $1, %rdi       # F(1)
    movq %rdi, %rbx     # F(i-1)
    movq %rax, %rcx     # F(i-2)
    movq $2, %rsi       # i = 2

fib_loop:
    addq %rbx, %rcx     # F(i) = F(i-1) + F(i-2)
    movq %rcx, %rbx     # F(i-1) = F(i)
    incq %rsi           # i++
    cmpq %rsi, %rdi     # compare i with n
    jne fib_loop        # continue loop if i != n

    movq %rcx, %rax     # return F(n)
    leave
    ret

main:           # start of main() function

 # Print input prompt
    movq $0, %rdi       # stdout
    leaq input_prompt(%rip), %rsi
    movq $0, %rax       # syscall number for sys_write
    call printf

    # Read integer input
    leaq input_buffer(%rip), %rdi
    leaq output_format(%rip), %rsi
    movq $0, %rax       # syscall number for sys_read
    call scanf

    # Get integer input from buffer
    movq input_buffer(%rip), %rdi
    call atoi           # convert ASCII input to integer

    # Validate input (0 <= n <= 40)
    cmpq $0, %rax
    jl exit_program     # if n < 0, exit program
    cmpq $40, %rax
    jg exit_program     # if n > 40, exit program

    # Print Fibonacci sequence up to n
    movq %rax, %rdi     # pass n as argument
    call fibonacci

    # Print newline
    movq $0, %rdi       # stdout
    movq $0xA, %rax     # newline character
    call putchar

exit_program:
    movq $0, %rax       # exit status 0
    ret

# Function to convert ASCII string to integer
atoi:
    pushq %rbp
    movq %rsp, %rbp
    xorq %rax, %rax     # clear accumulator
    movq (%rdi), %r8    # load first character

atoi_loop:
    cmpq $0x30, %r8     # check if character is '0'
    jl atoi_done        # stop loop if non-numeric character
    cmpq $0x39, %r8     # check if character is '9'
    jg atoi_done        # stop loop if non-numeric character
    subq $0x30, %r8     # convert character to integer
    imulq $10, %rax     # multiply current number by 10
    addq %r8, %rax      # add digit to accumulator
    incq %rdi           # move to next character
    movq (%rdi), %r8    # load next character
    jmp atoi_loop

atoi_done:
    leave
    ret

.section .bss
input_buffer:   .skip 32    # buffer for input (max 32 bytes for integer)