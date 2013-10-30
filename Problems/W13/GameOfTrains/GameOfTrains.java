import java.util.*;

public class GameOfTrains {
   private static final int UD = 0, LR = 1;
   
   static class Position {
      int x, y, d;
      public Position(int xs, int ys, int ds) {
         x = xs;
         y = ys;
         d = ds;
      }
      public String toString() {return "("+x+","+y+","+(d==UD?"UD":"LR")+")";}
   }
   
   public static boolean DFS(char[][] board, Queue<Position> queue) {
      while (queue.size() > 0) {
         Position p = queue.remove();
         char c = getChar(board,p.x,p.y);
         if (c == ' ')
            continue;
         if (c == 'E')
            return true;
         if (p.d == UD && c == '-' || p.d == LR && c == '|')
            continue;
         
         
         if (c == '*' || p.d == UD) {
            queue.offer(new Position(p.x, p.y-1, UD));
            queue.offer(new Position(p.x, p.y+1, UD));
         }
         
         if (c == '*' || p.d == LR) {
            queue.offer(new Position(p.x-1, p.y, LR));
            queue.offer(new Position(p.x+1, p.y, LR));
         }
         
         board[p.y][p.x] = c == '+' ?  (p.d == UD ? '-' : '|') : ' ';
      }
      return false;
   }
   
   public static char getChar(char[][] board, int x, int y) {
      if (x < 0 || x >= board[0].length || y < 0 || y >= board.length)
         return ' ';
      return board[y][x];
   }
   
   public static void main(String[] args) {
      Scanner scan = new Scanner(System.in);
      int H = scan.nextInt(), W = scan.nextInt();
      char[][] board = new char[H][W];
      Position p = null;
      scan.nextLine();
      
      for (int i = 0; i < H; i++) {
         char[] line = scan.nextLine().toCharArray();
         for (int o = 0; o < W; o++) {
            if (line[o] == 'S') {
               p = new Position(o, i, 0);
               board[i][o] = ' ';
            } else {
               board[i][o] = line[o];
            }
         }
      }
      
      Queue<Position> queue = new LinkedList<Position>();
      char c = getChar(board, p.x-1, p.y);
      if (c == '-' || c == '+' || c == '*')
         queue.offer(new Position(p.x-1, p.y, LR));
      
      c = getChar(board, p.x+1, p.y);
      if (c == '-' || c == '+' || c == '*')
         queue.offer(new Position(p.x+1, p.y, LR));
      
      c = getChar(board, p.x, p.y-1);
      if (c == '|' || c == '+' || c == '*')
         queue.offer(new Position(p.x, p.y-1, UD));
      
      c = getChar(board, p.x, p.y+1);
      if (c == '|' || c == '+' || c == '*')
         queue.offer(new Position(p.x, p.y+1, UD));
      
      System.out.println("I "+(DFS(board, queue) ? "win!" : "lose..."));
   }
}
