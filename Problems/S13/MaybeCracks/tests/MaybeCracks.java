import java.util.*;
import java.awt.Point;

public class MaybeCracks {
   public static boolean canTraverse(Scanner scan) {
      int N = scan.nextInt();
      List<Point> fringe = new LinkedList<Point>();
      
      scan.nextLine();
      fringe.add(new Point(0, 0));
      
      while (N-- > 0 && !fringe.isEmpty()) {
         int curr = scan.nextInt();
         
         List<Point> toAdd = new ArrayList<Point>(fringe.size());
         Iterator<Point> i = fringe.iterator();
         
         while (i.hasNext()) {
            Point p = i.next();
            
            p.y += curr;
            
            if (p.x == 0 || p.x == p.y+1 || p.x == p.y || p.x == p.y-1)
               toAdd.add(new Point(p.y, 0));
            if (p.x != 0 && p.y > p.x)
               i.remove();
         }
         
         fringe.addAll(toAdd);
         
         if (N != 0 && scan.next().equals("|")) {
            i = fringe.iterator();
            
            while (i.hasNext())
               if (i.next().y > 0)
                  i.remove();
         }
      }
      
      for (Point p : fringe)
        if (p.y == 0)
           return true;
      return false; 
      
   }
   
   public static void main(String[] args) {
      System.out.println(canTraverse(new Scanner(System.in)) ? "Yes" : "No");
   }
}
