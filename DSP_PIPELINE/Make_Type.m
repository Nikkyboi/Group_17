function TypeFilt = Make_Type(ApproxType)
    
    %This function takes 1 input (ApproxType) from global specs and outputs
    %The string to be used in the functions Make_Butt, Make_ChebychevI, 
    %Make_ChebychevII, Make_Cauer. We have to make lp, hp,
    %bp and bs into other strings which the functions can use. These are low,
    %high, band and stop, respectavlily.
    if ApproxType== "lp"
        TypeFilt = 'low';
    elseif ApproxType== "hp"
        TypeFilt = 'high';
    elseif ApproxType== "bp"
        TypeFilt = 'bandpass';
    elseif ApproxType== "bs"
        TypeFilt = 'stop';
    else
        error('Error in TypeFilt, type of filter not recognized. Try lp, hp, bp or bs')
    end

end