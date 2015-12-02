BITS 16

start:
	mov ax, 0x07C0			; Clear out 4k of stack space after the bootloader
	add ax, 288				; Define segment size? (4096 + 512) / 16 = 288 bytes per paragraph
	mov ss, ax
	mov sp, 4096			

	mov ax, 0x07C0			; Set the data segment to where the bootloader is loaded (so we can properly find our strings)
	mov ds, ax

	mov si, boot_string		; Put our string into the source index register for "parsing"
	call print_string		; Call the subroutine that prints the string in SI

	call read_keyboard

	jmp $					; jmp to *this* line infinitely (prevents the string from being processed as executable code)

	boot_string db 'Hello World, from OSam', 0


read_keyboard:
	call print_newline

.repeat:
	mov ah, 0
	int 0x16
	cmp al, 0x0D
	je .done
	mov ah, 0x0E
	int 0x10
	jmp .repeat

.done:
	call print_newline
	ret



print_newline:
	mov ah, 0x0E
	mov al, 10
	int 0x10
	mov al, 13
	int 0x10
	
	mov al, 0x0
	mov ah, 0x0
	ret


print_string:
	mov ah, 0x0E			; Tells the BIOS to print a single character when `print char` is called

.repeat:
	lodsb					; Get character from string
	cmp al, 0				; Has the iteration reached the end of the string (remeber strings are terminated with a zero)
	je .done				; It has been reached
	int 0x10				; It hasn't, so call `print char` in the BIOS
	jmp .repeat				; Keep iterating

.done:
	ret


	times 510-($-$$) db 0	; Padding remaining space
	dw 0xAA55				; Identifies boot sector
