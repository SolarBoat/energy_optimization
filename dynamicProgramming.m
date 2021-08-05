function [distance, u, b, J, Edistance] = dynamicProgramming(tDiscrete, uMax, bMax, db, b0, w0, L, E, cp, solar, Wweather, weight)
    Nt = length(tDiscrete);
    Nb = bMax / db + 1;
    Ns = size(Wweather, 1);
    Nw = Ns;
    J = zeros(Nb, Nw, Nt);
    Jd = zeros(Nb, Nw, Nt);
    
    % backward sweep
    for i = 1:Nb
        for j = 1:Nw
            J(i, j, end) = E((i - 1) * db);
        end
    end
    for k = (Nt - 1):-1:1
        h = tDiscrete(k + 1) - tDiscrete(k);
        
        for iw = 1:Nw
            fconst = solar{iw}(tDiscrete(k),tDiscrete(k+1)) - h * cp;

            for ib = 1:Nb
                ibnextmax = floor(ib + fconst / db);
                if ibnextmax < 1
                    J(ib, iw, k) = weight;
                    continue
                end
                if ibnextmax > Nb
                    ibnextmax = Nb;
                end
                ibnextmin = ibnextmax - floor(uMax * h / db)  + 1;
                if ibnextmin < 1
                    ibnextmin = 1;
                end
                if ibnextmin > Nb
                    J(ib, iw, k) = weight;
                    continue
                end
                Lmin = inf;
                Dmin = 0;
                for ibnext = ibnextmin:ibnextmax
                    u_k = ((ib - ibnext) * db + fconst) / h;
                    l = 0;
                    d = 0;
                    for iwnext = 1:Nw
                        l = l + Wweather(iw, iwnext) * (h * L(u_k) + J(ibnext, iwnext, k+1));
                        d = d + Wweather(iw, iwnext) * (h * L(u_k) + Jd(ibnext, iwnext, k+1));
                    end
                    if l < Lmin
                        Lmin = l;
                        Dmin = d;
                    end
                end
                J(ib, iw, k) = Lmin;
                Jd(ib, iw, k) = Dmin;
            end
        end
    end
    
    % forward sweep
    b = zeros(Nt + 1, 1);
    u = zeros(Nt, 1);
    b(1) = b0;
    distance = 0;
    Edistance = 0;
    for k = 1:Nt
        if k == 1
            h = tDiscrete(1);
            fconst = solar{w0}(0,tDiscrete(k)) - h * cp;
        else
            h = tDiscrete(k) - tDiscrete(k - 1);
            fconst = solar{w0}(tDiscrete(k - 1),tDiscrete(k)) - h * cp;
        end
        
        ib = b(k) / db + 1;
        ibnextmax = floor(ib + fconst / db);
        if ibnextmax < 1
            disp("impossible")
            distance = 0;
            return
        end
        if ibnextmax > Nb
            ibnextmax = Nb;
        end
        ibnextmin = ibnextmax - floor(uMax * h / db)  + 1;
        if ibnextmin < 1
            ibnextmin = 1;
        end
        if ibnextmin > Nb
            disp("ennergy overload")
            distance = 0;
            return
        end
        Lmin = inf;
        for ibnext = ibnextmin:ibnextmax
            u_k = ((ib - ibnext) * db + fconst) / h;
            l = 0;
            for iwnext = 1:Nw
                l = l + Wweather(w0, iwnext) * (h * L(u_k) + J(ibnext, iwnext, k));
            end
            if l < Lmin
                Lmin = l;
                u(k) = u_k;
                b(k+1) = (ibnext - 1) * db;
            end
        end
        
        if Lmin == inf
            disp("impossible")
            distance = 0;
            return
        end
        distance = distance + h * L(u(k));
    end
    distance = -distance;
    Edistance = max(0,-Jd(round(b0/db+1), w0, 1));
end