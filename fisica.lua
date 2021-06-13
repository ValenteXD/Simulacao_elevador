local fisica = {}
local g = 9.8
function fisica.peso(m)
  
  return m * g
  
  ---resultado em N-
end
function fisica.tracao(McontP, acel)
  
  return McontP * acel + fisica.peso(McontP)
  
  --resultado em N--
end
function fisica.forcaMotor(McontP, Melev, acel)
  
  return Melev * acel + fisica.peso(Melev) - fisica.tracao(McontP, acel)
  
  --resultado em N--
end
function fisica.potencia(Vel, McontP, Melev, acel)
  
  return fisica.forcaMotor(McontP, Melev, acel) * Vel
  
  --resultado em W--
end
function fisica.energia(Vel,dt, McontP, Melev, acel)
  
  return fisica.potencia(Vel, McontP, Melev, acel) * dt / 1000 * 3600
  
  --resultado em kWh--
end
  
  --return (McontP - Melev) / (McontP + Melev) * g
  
  --resultado em m/s^2--
--end
return fisica