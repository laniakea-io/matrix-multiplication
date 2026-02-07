### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 4659c4b5-0d8c-43c5-ae1f-ffce621058f6
using BenchmarkTools

# ╔═╡ 3bf9a894-8f88-4fab-be05-74bb86fcd09b
function matmul!(C::AbstractMatrix, A::AbstractMatrix, B::AbstractMatrix)
    # Dimensiones
    m, kA = size(A)
    kB, n = size(B)

    @assert kA == kB
    @assert size(C) == (m, n)

    fill!(C, zero(eltype(C)))

    # bucle ijk
    for i in 1:m          
        for j in 1:n
            sum = zero(eltype(C))
            for k in 1:kA 
                sum += A[i, k] * B[k, j]
            end
            C[i, j] = sum
        end
    end
    return C
end

# ╔═╡ e735474a-837c-47bb-a990-fb69108ff958
function matmul(A::AbstractMatrix, B::AbstractMatrix)
    m, kA = size(A)
    kB, n = size(B)
    @assert kA == kB
    C = similar(A, m, n)
    return matmul!(C, A, B)
end

# ╔═╡ bf1fdd31-8780-409f-aa99-8b70c5f3a69a
function strmul(A::Matrix, B::Matrix)
	n = size(A, 1);
    if n <= 2
        C = A * B;
	else
        k = convert(Int, n/2);
        # Dividir en 4 submatrices
        A11 = A[1:k, 1:k]
		A12 = A[1:k, k+1: n]
		A21 = A[k+1:n, 1:k]
		A22 = A[k+1:n, k+1:n]
		B11 = B[1:k, 1:k]
		B12 = B[1:k, k+1:n]
		B21 = B[k+1:n, 1:k]
		B22 = B[k+1:n, k+1:n]

        # Productos intermedios
        M1 = strmul(A11 + A22, B11 + B22)
        M2 = strmul(A21 + A22, B11)
        M3 = strmul(A11, B12 - B22)
        M4 = strmul(A22, B21 - B11)
        M5 = strmul(A11 + A12, B22)
        M6 = strmul(A21 - A11, B11 + B12)
        M7 = strmul(A12 - A22, B21 + B22)

        # Combinación de resultados
        C11 = M1 + M4 - M5 + M7
        C12 = M3 + M5
        C21 = M2 + M4
        C22 = M1 - M2 + M3 + M6

        # Construir la matriz resultado
        C = [C11 C12; C21 C22];
    end
end

# ╔═╡ 228d0eec-9f45-4fe9-954c-6b129fa214f7
n = 256

# ╔═╡ 4d642323-ece0-4610-8a23-ffd9cb77c5b1
L = rand(Int8, n, n)

# ╔═╡ f539b5eb-0684-494b-aa8c-076841ee332a
R = rand(Int8, n, n)

# ╔═╡ 8e5291df-2eee-476b-ba1e-49ed3bfcb826
strmul(L,R)

# ╔═╡ 0fe60ae8-c8e0-4101-9cb8-28983d046340
matmul(L,R)

# ╔═╡ 069abefd-4740-4f29-835e-4a25e4723891
L*R

# ╔═╡ a2cf6101-cc97-4f2e-b372-ca87cfbd3ff7
strassen = @benchmark strmul(L,R) seconds=60

# ╔═╡ a3df2b81-28b8-48bf-8606-3c33e0897573
standard = @benchmark strmul(L,R) seconds=60

# ╔═╡ 13cbcc8d-1819-4cff-b935-efb2012af6b0
julia = @benchmark L*R seconds=60

# ╔═╡ b613aa65-9e02-4091-9f95-6713bf5233ed
mean(strassen)

# ╔═╡ 25a4bc33-0bd6-4e72-bbe6-0626bfee75e7
mean(standard)

# ╔═╡ 96910ba5-7008-4628-b27c-c95b2e4c1174
mean(julia)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"

[compat]
BenchmarkTools = "~1.6.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.4"
manifest_format = "2.0"
project_hash = "60a9c3d9f9291c5f2afe284110b68788f2a1bc46"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.BenchmarkTools]]
deps = ["Compat", "JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "7fecfb1123b8d0232218e2da0c213004ff15358d"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.6.3"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Logging", "Parsers", "PrecompileTools", "StructUtils", "UUIDs", "Unicode"]
git-tree-sha1 = "5b6bb73f555bc753a6153deec3717b8904f5551c"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "1.3.0"

    [deps.JSON.extensions]
    JSONArrowExt = ["ArrowTypes"]

    [deps.JSON.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "07a921781cab75691315adc645096ed5e370cb77"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "522f093a29b31a93e34eaea17ba055d850edea28"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Profile]]
deps = ["StyledStrings"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StructUtils]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "b0290a55d9e047841d7f5c472edbdc39c72cd0ce"
uuid = "ec057cc2-7a8d-4b58-b3b3-92acb9f63b42"
version = "2.6.1"

    [deps.StructUtils.extensions]
    StructUtilsMeasurementsExt = ["Measurements"]
    StructUtilsTablesExt = ["Tables"]

    [deps.StructUtils.weakdeps]
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"
"""

# ╔═╡ Cell order:
# ╠═4659c4b5-0d8c-43c5-ae1f-ffce621058f6
# ╠═3bf9a894-8f88-4fab-be05-74bb86fcd09b
# ╠═e735474a-837c-47bb-a990-fb69108ff958
# ╠═bf1fdd31-8780-409f-aa99-8b70c5f3a69a
# ╠═228d0eec-9f45-4fe9-954c-6b129fa214f7
# ╠═4d642323-ece0-4610-8a23-ffd9cb77c5b1
# ╠═f539b5eb-0684-494b-aa8c-076841ee332a
# ╠═8e5291df-2eee-476b-ba1e-49ed3bfcb826
# ╠═0fe60ae8-c8e0-4101-9cb8-28983d046340
# ╠═069abefd-4740-4f29-835e-4a25e4723891
# ╠═a2cf6101-cc97-4f2e-b372-ca87cfbd3ff7
# ╠═a3df2b81-28b8-48bf-8606-3c33e0897573
# ╠═13cbcc8d-1819-4cff-b935-efb2012af6b0
# ╠═b613aa65-9e02-4091-9f95-6713bf5233ed
# ╠═25a4bc33-0bd6-4e72-bbe6-0626bfee75e7
# ╠═96910ba5-7008-4628-b27c-c95b2e4c1174
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
