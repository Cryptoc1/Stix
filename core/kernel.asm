BITS 16

disk_buffer	equ	24576

kernel_entry_point:
	jmp os_main
	jmp os_print_string

os_main:
	cli							; Clear interrupts
	mov ax, 0
	mov ss, ax					; Set stack segment and pointer
	mov sp, 0x0FFFF
	sti							; Restore interrupts

	cld							; The default direction for string operations
								; will be 'up' - incrementing address in RAM

	mov ax, 0x2000				; Set all segments to match where kernel is loaded
	mov ds, ax					; After this, we don't need to bother with
	mov es, ax					; segments ever again, as MikeOS and its programs
	mov fs, ax					; live entirely in 64K
	mov gs, ax

	mov si, hello_world
	call os_print_string

	jmp $

os_print_string:
	pusha
	mov ah, 0x0E
.repeat:
	lodsb
	cmp al, 0
	je .done
	int 0x10
	jmp .repeat
.done:
	popa
	ret


	hello_world db 'Hello world!', 0
