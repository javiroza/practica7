! ----------------------------------- Pràctica 7 --------------------------------------- !
! Autor: Javier Rozalén Sarmiento
! Grup: B1B
! Data: 26/11/2019
!
! Funcionalitat: es programen i es posen a prova els mètodes d'Euler i Predictor-Corrector   
! per a la resolució d'equacions diferencials ordinàries
!
! Comentaris: Les variables que tinguin per nom "theta_" corresponen a l'angle que forma el
! pèndol amb la vertical, mentre que les variables "w_" són les derivades temporals de les 
! "theta_". En aquesta pràctica, per comoditat, he programat subrutines que implementen els
! mètodes de resolució d'equacions diferencials complets (amb el bucle inclòs); sóc 
! conscient que l'ideal seria fer un únic pas i treure els bucles fora, pero en aquesta 
! pràctica en particular es guanya claredat i espai.

program practica7
    implicit none
    double precision m,g,l,pi,t0,tN,theta_0,w_0
    double precision fun1,fun2
    integer N,arxiu
    external fun1,fun2
    common/cts/m,g,l
    
    m=0.98d0 ! Massa del pèndol
    g=10.44d0 ! Gravetat (Venus)
    l=1.07d0 ! Longitud del pèndol
    pi=dacos(-1.d0)
    t0=0.d0
    tN=2.d0*pi/dsqrt(g/l)
    arxiu=11

    open(11,file="P7-1920-resf.dat")
    write(11,*) "#Temps, Angle, Velocitat angular, Energia cinètica, Energia potencial, Energia mecànica"

    ! -------------------------------- Apartat a) --------------------------------------- !
    theta_0=0.025
    w_0=0.d0
    N=1500

    call euler(theta_0,w_0,t0,7.d0*tN,N,fun2,arxiu) ! index 0 (gnuplot)
    call write(arxiu) 
    call pred_corr(theta_0,w_0,t0,7.d0*tN,N,fun2,arxiu) ! index 1 (gnuplot)

    ! -------------------------------- Apartat b) --------------------------------------- !
    theta_0=pi-0.15
    w_0=0.d0
    N=1500

    call write(arxiu)
    call euler(theta_0,w_0,t0,7.d0*tN,N,fun1,arxiu) ! index 2 (gnuplot)
    call write(arxiu)
    call pred_corr(theta_0,w_0,t0,7.d0*tN,N,fun1,arxiu) ! index 3 (gnuplot)

    ! -------------------------------- Apartat c) --------------------------------------- !
    w_0=0.12D0
    N=1500
    theta_0=pi-0.025

    call write(arxiu)
    call euler(theta_0,w_0,t0,5.d0*tN,N,fun1,arxiu) ! index 4 (gnuplot)
    call write(arxiu)
    call pred_corr(theta_0,w_0,t0,5.d0*tN,N,fun1,arxiu) ! index 5 (gnuplot)


    ! -------------------------------- Apartat d) --------------------------------------- !
    theta_0=0.d0
    N=6000

    ! Condició 1
    w_0=2.d0*dsqrt(g/l)+0.05d0
    call write(arxiu)
    call pred_corr(theta_0,w_0,t0,15.d0*tN,N,fun1,arxiu) ! index 6 (gnuplot)     

    ! Condició 2
    w_0=2.d0*dsqrt(g/l)-0.05d0
    call write(arxiu)
    call pred_corr(theta_0,w_0,t0,15.d0*tN,N,fun1,arxiu) ! index 7 (gnuplot) 

    ! -------------------------------- Apartat e) --------------------------------------- !
    theta_0=2.87d0
    w_0=0.d0

    ! N=300
    N=300
    call write(arxiu)
    call pred_corr(theta_0,w_0,t0,11.d0*tN,N,fun1,arxiu) ! index 8 (gnuplot)

    ! N=550
    N=550
    call write(arxiu)
    call pred_corr(theta_0,w_0,t0,11.d0*tN,N,fun1,arxiu) ! index 9 (gnuplot)

    ! N=1000
    N=1000
    call write(arxiu)
    call pred_corr(theta_0,w_0,t0,11.d0*tN,N,fun1,arxiu) ! index 10 (gnuplot)

    ! N=20000
    N=20000
    call write(arxiu)
    call pred_corr(theta_0,w_0,t0,11.d0*tN,N,fun1,arxiu) ! index 11 (gnuplot)
  

    close(11)
end program practica7

! Subrutina euler --> Escriu en un arxiu l'evolució temporal del pèndol simple calculada 
! amb el mètode d'Euler
subroutine euler(theta_0,w_0,t0,tN,N,funcio,arxiu)
    implicit none
    double precision theta_n1,theta_n,w_n1,w_n,theta_0,w_0,t0,tN,h,funcio
    double precision EKIN,EPOT,Etotal
    integer arxiu,i,N

    h=(tN-t0)/dble(N) ! Pas 
    theta_n=theta_0
    w_n=w_0

    write(arxiu,*) t0,theta_n,w_n

    ! Amb els primers valors calculats amb les condicions inicials, iniciem el bucle
    do i=1,N-1 ! Ja hem escrit un valor (sense comptar les cond. inicials)
        ! Noves variables theta_n1,w_n1
        theta_n1=theta_n+h*w_n
        w_n1=w_n+h*funcio(theta_n)
        ! Escrivim a l'arxiu les noves variables
        write(arxiu,*) t0+(i+1)*h,theta_n1,w_n1,EKIN(w_n1),EPOT(theta_n1),Etotal(theta_n1,w_n1)
        ! Sobreescrivim variables
        theta_n=theta_n1
        w_n=w_n1
    enddo

    return
end subroutine euler

! Subrutina pred_corr--> Escriu en un arxiu l'evolució temporal del pèndol simple calculada 
! amb el mètode predictor-corrector
subroutine pred_corr(theta_0,w_0,t0,tN,N,funcio,arxiu)
    implicit none
    double precision theta_n1,theta_n,theta_n1p,w_n1,w_n,w_n1p,theta_0,w_0,t0,tN,h,funcio
    double precision EKIN,EPOT,Etotal
    integer arxiu,i,N

    h=(tN-t0)/dble(N) ! Pas 

    theta_n=theta_0
    w_n=w_0

    ! Escrivim les dades corresponents a les condicions inicials
    write(arxiu,*) t0,theta_n,w_n,EKIN(w_n),EPOT(theta_n),Etotal(theta_n,w_n)

    do i=1,N   
        ! Fem una primera predicció
        w_n1p=w_n+h*funcio(theta_n)
        theta_n1p=theta_n+h*w_n 

        ! Calculem el següent pas a partir de la predicció
        theta_n1=theta_n+(h/2.d0)*(w_n+w_n1p)
        w_n1=w_n+(h/2.d0)*(funcio(theta_n)+funcio(theta_n1p))

        ! Escrivim a l'arxiu les noves variables
        write(arxiu,*) t0+i*h,theta_n1,w_n1,EKIN(w_n1),EPOT(theta_n1),Etotal(theta_n1,w_n1)

        ! Sobreescrivim variables
        theta_n=theta_n1
        w_n=w_n1
    enddo

    return
end subroutine pred_corr

! Subrutina write --> Escriu dues línies en blanc en un arxiu
subroutine write(arxiu)
    implicit none
    integer arxiu
    write(arxiu,*) ""
    write(arxiu,*) ""
    return
end subroutine

! Funció EKIN --> Energia cinètica del pèndol en funció de w
double precision function EKIN(w)
    implicit none
    double precision w
    double precision m,g,l
    common/cts/m,g,l
    EKIN=0.5d0*m*(w*l)**2.d0
    return
end function EKIN

! Funció EPOT --> Energia potencial del pèndol en funció de theta
double precision function EPOT(theta)
    implicit none
    double precision theta
    double precision m,g,l
    common/cts/m,g,l
    EPOT=-m*g*l*dcos(theta)
    return
end function EPOT

! Funció Etotal --> Energia total del pèndol (constant del moviment)
double precision function Etotal(theta,w)
    implicit none
    double precision theta,w,EPOT,EKIN
    Etotal=EPOT(theta)+EKIN(w)
    return
end function Etotal

! Funció fun1 --> funció auxiliar 1 (grans oscil·lacions)
double precision function fun1(theta)
    implicit none
    double precision theta
    double precision m,g,l
    common/cts/m,g,l
    fun1=-(g/l)*dsin(theta)
    return
end function fun1

! Funció fun2 --> funció auxiliar 2 (petites oscil·lacions)
double precision function fun2(theta)
    implicit none
    double precision theta
    double precision m,g,l
    common/cts/m,g,l
    fun2=-(g/l)*theta
    return
end function fun2