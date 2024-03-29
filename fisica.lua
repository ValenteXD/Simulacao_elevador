local fisica = {}
local g = 9.8
function fisica.peso(m)
  
  return m * g
  
  ---resultado em N-
end
function fisica.tracao(McontP,acel)
  
  if subida then
    return fisica.peso(McontP) + (McontP * acel) 
  elseif descida then
    return -(McontP * acel) + fisica.peso(McontP)
  else
    return fisica.peso(McontP)
  end
  
  --resultado em N--
end
function fisica.forcaMotor(McontP, Melev, acel)
  
  if subida then
    return math.abs(-Melev * acel + fisica.peso(Melev) - fisica.tracao(McontP, acel))
  elseif descida then
    return math.abs(Melev * acel + fisica.peso(Melev) - fisica.tracao(McontP, acel))
  else
    return fisica.peso(Melev) - fisica.tracao(McontP,acel)
  end
  
  --resultado em N--
end
function fisica.potencia(Vel, McontP, Melev, acel)
  
  return fisica.forcaMotor(McontP, Melev, acel) * Vel
  
  --resultado em W--
end
function fisica.energia(Vel,dt, McontP, Melev, acel)
  
  return fisica.potencia(Vel, McontP, Melev, acel) * dt
  
  --resultado em kWh--
end
  
  --return (McontP - Melev) / (McontP + Melev) * g
  
  --resultado em m/s^2--
--end
return fisica