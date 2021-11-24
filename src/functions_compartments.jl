# Fonctions permettant de calculer des modèles types SIR/SEIR 



export SIR ; 
"""
Function SIR 

"""
function SIR(β::float64,γ::float64,S0::float64) 

    S = zeros(Float64,ParamSIR.NB_DT) ; 
    I = zeros(Float64,ParamSIR.NB_DT) ; 
    R = zeros(Float64,ParamSIR.NB_DT) ; 
    R0 = β/γ ; 
    println("Compute SEIR model with R_0 = ", R0) ; 

    # Initial conditions
    S[1] = S0 ; 
    I[1] = 1 - S0 ; 

    for i=2:ParamSIR.NB_DT
        S[i+1] = (1 - β*I[i])*S[i] ; 
        I[i+1] = (1 + β*S[i] - γ)*I[i] ; 
        R[i+1] = γ*I[i]+R[i] ; 
    end 

    return(S,I,R)

end 


export SEIR ; 

function SEIR(α::float64,β::float64,γ::float64,S0::float64) 

    S = zeros(Float64,ParamSEIR.NB_DT) ; 
    E = zeros(Float64,ParamSEIR.NB_DT) ; 
    I = zeros(Float64,ParamSEIR.NB_DT) ; 
    R = zeros(Float64,ParamSEIR.NB_DT) ; 
    
    R0 = β/γ ; 
    println("Compute SEIR model with R_0 = ", R0) ;

    # Initial conditions 
    S[1] = S0 ; 
    I[1] = 1-S0 ; 

    for i=2:ParamSEIR.NB_DT
        S[i+1] = (1 - β*I[i])*S[i] ; 
        E[i+1] = β*S[i]*I[i] + (1-α)*E[i] ; 
        I[i+1] = α*E[i] + (1-γ)*I[i] ; 
        R[i+1] = γ*I[i]+R[i] ; 
    end 

    return()

end




