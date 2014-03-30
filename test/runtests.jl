using CRC
using Base.Test
using IntModN

function test_rem_no_table()
    print("rem_no_table")

    for _ in 1:10

        # an 8th degree generator with 2 bytes of data.  do the check as
        # 64 bit polynpomial division (don't forget zero padding).
        a1 = rand(Uint8, 2)
        b1 = rand(Uint8)
        a2 = convert(Uint64, convert(Uint64, a1[1]) << 16 + convert(Uint64, a1[2]) << 8)
        b2 = convert(Uint64, (1 << 8) | b1)
        c1 = rem_no_table(8, b1, a1)
        c2 = GF2Poly(a2) % GF2Poly(b2)
        @test c1 < b2
        @test c2.i < b2
        @test c2.i == c1
        print(".")

        # a 16th degree polynomial with 3 bytes of data (now 16 bits
        # of padding)
        a1 = rand(Uint8, 3)
        b1 = rand(Uint16)
        a2 = convert(Uint64, convert(Uint64, a1[1]) << 32 + convert(Uint64, a1[2]) << 24 + convert(Uint64, a1[3]) << 16)
        b2 = convert(Uint64, (1 << 16) | b1)
        c1 = rem_no_table(16, b1, a1)
        c2 = GF2Poly(a2) % GF2Poly(b2)
        @test c1 < b2
        @test c2.i < b2
        @test c2.i == c1
        print(".")

        # using the same data, a 9th degree polynomial with 3 bytes
        # of data (now 9 bits of padding)
        b1 = convert(Uint16, (1 << 9) | (b1 & ((1 << 9) - 1)))
        a2 = convert(Uint64, convert(Uint64, a1[1]) << 25 + convert(Uint64, a1[2]) << 17 + convert(Uint64, a1[3]) << 9)
        b2 = convert(Uint64, b1)
        c1 = rem_no_table(9, b1, a1)
        c2 = GF2Poly(a2) % GF2Poly(b2)
        @test c1 < b2
        @test c2.i < b2
        @test c2.i == c1
        print(".")

    end

    println("ok")
end

function test_rem_single_table()
    print("rem_single_table")

    for _ in 1:10

        # an 8th degree generator with 2 bytes of data.  do the check as
        # 64 bit polynpomial division (don't forget zero padding).
        a1 = rand(Uint8, 2)
        b1 = rand(Uint8)
        a2 = convert(Uint64, convert(Uint64, a1[1]) << 16 + convert(Uint64, a1[2]) << 8)
        b2 = convert(Uint64, (1 << 8) | b1)
        c1 = rem_single_table(8, b1, a1, single_table(8, b1, 8*sizeof(a1[1])))
        c2 = GF2Poly(a2) % GF2Poly(b2)
        @test c1 < b2
        @test c2.i < b2
        @test c2.i == c1
        print(".")

        # a 16th degree polynomial with 3 bytes of data (now 16 bits
        # of padding)
        a1 = rand(Uint8, 3)
        b1 = rand(Uint16)
        a2 = convert(Uint64, convert(Uint64, a1[1]) << 32 + convert(Uint64, a1[2]) << 24 + convert(Uint64, a1[3]) << 16)
        b2 = convert(Uint64, (1 << 16) | b1)
        c1 = rem_single_table(16, b1, a1, single_table(16, b1, 8*sizeof(a1[1])))
        c2 = GF2Poly(a2) % GF2Poly(b2)
        @test c1 < b2
        @test c2.i < b2
        @test c2.i == c1
        print(".")

        # using the same data, a 9th degree polynomial with 3 bytes
        # of data (now 9 bits of padding)
        b1 = convert(Uint16, (1 << 9) | (b1 & ((1 << 9) - 1)))
        a2 = convert(Uint64, convert(Uint64, a1[1]) << 25 + convert(Uint64, a1[2]) << 17 + convert(Uint64, a1[3]) << 9)
        b2 = convert(Uint64, b1)
        c1 = rem_single_table(9, b1, a1, single_table(9, b1, 8*sizeof(a1[1])))
        c2 = GF2Poly(a2) % GF2Poly(b2)
        @test c1 < b2
        @test c2.i < b2
        @test c2.i == c1
        print(".")

    end

    println("ok")
end

srand(0)  # repeatable results
test_rem_no_table()
test_rem_single_table()

