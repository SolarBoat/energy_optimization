function [distance, u, x] = dynamicProgramming(tDiscrete, uDiscrete, xMax, dx, x0, L, E, cp, solar, Wsolar)
    Nt = length(tDiscrete);
    Nx = xMax / dx + 1;
    Ns = length(Wsolar);
    J = zeros(Nx, Nt);
    h = 0.5;
    
    % backward sweep
    for i = 1:Nx
        J(i,end) = E((i - 1) * dx);
    end
    for k = (Nt - 1):-1:1
        h = tDiscrete(k + 1) - tDiscrete(k);
        fconst = zeros(Ns, 1);
        for j = 1:Ns
            fconst(j) = solar{j}(tDiscrete(k),tDiscrete(k+1)) - h * cp;
        end
        for i = 1:Nx
            Lmin = inf;
            for uk = uDiscrete
                l = 0;
                for j = 1:Ns
                    xNext = (i - 1) * dx + fconst(j) - h * uk;
                    if 0 <= xNext & xNext <= xMax
                        l = l + Wsolar(j) * (h * L(uk) + J(round(xNext / dx) + 1, k+1));
                    else
                        l = l + Wsolar(j) * 100000;
                    end
                end
                if l < Lmin
                    Lmin = l;
                end
            end
            J(i, k) = Lmin;
        end
    end
    
    % forward sweep
    x = zeros(Nt + 1, 1);
    u = zeros(Nt, 1);
    x(1) = x0;
    distance = 0;
    for k = 1:Nt
        if k == 1
            h = tDiscrete(1);
            fconst = solar{1}(0,tDiscrete(k)) - h * cp;
        else
            h = tDiscrete(k) - tDiscrete(k - 1);
            fconst = solar{1}(tDiscrete(k - 1),tDiscrete(k)) - h * cp;
        end
        Lmin = inf;
        for uk = uDiscrete
            xNext = x(k) + fconst - h * uk;
            if 0 <= xNext & xNext <= xMax
                l = h * L(uk) + J(round(xNext / dx) + 1, k);
            else
                l = inf;
            end
            if l < Lmin
                Lmin = l;
                u(k) = uk;
                x(k+1) = xNext;
            end
        end
        distance = distance + h * L(u(k));
    end
    distance = -distance;
end