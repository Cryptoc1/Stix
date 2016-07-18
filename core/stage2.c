void main() {
    int attr = 0x0F;
    unsigned short *where = (unsigned short *)0xB8000 + 323;
    *where = (unsigned char)"!" | (unsigned)(attr << 8);


    while(1) {

    };
};
