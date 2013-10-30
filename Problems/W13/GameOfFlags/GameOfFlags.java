import java.util.*;

public class GameOfFlags {
   public static void main(String[] args) {
      Scanner scan = new Scanner(System.in);
      int N = scan.nextInt(), K = scan.nextInt();
      int i, o;
      int[] a = new int[K];
      boolean[] isN = new boolean[N+1];
      
      for (i = 0; i < K; i++)
         a[i] = scan.nextInt();
      Arrays.sort(a);
      
      for (i = 0; i < N+1; i++)
         for (o = 0; !isN[i] && o < K; o++)
            if (i - a[o] >= 0 && !isN[i - a[o]])
               isN[i] = true;
      
      //for (o = 0; o < N+1; o++)
         //System.err.print((isN[o] ? 'N':'P')+" ");
      //System.err.println();
      System.out.println("I "+(isN[N] ? "win!" : "lose..."));
   }
}
