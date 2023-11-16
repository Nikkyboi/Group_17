function TypeFilt = Make_Type(ApproxType)
    
    %This function takes 1 input (ApproxType) from global specs and outputs
    %The string to be used in the function butter. We have to make lp, hp,
    %bp and bs into other strings which butter can use. These are low,
    %high, band and stop, respectavlily.
    if ApproxType== "lp"
        TypeFilt = 'low';
    elseif ApproxType== "hp"
        TypeFilt = 'high';
    elseif ApproxType== "bp"
        TypeFilt = 'band';
    elseif ApproxType== "bs"
        TypeFilt = 'stop';
    else
        error('Error in TypeFilt, type of filter not recognized')
    end

end