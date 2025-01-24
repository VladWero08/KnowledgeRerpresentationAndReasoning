import os
import socket

class API:
    def __init__(self):
        self.base_dir = os.path.dirname(os.path.abspath(__file__))
        self.html = None
        html_path = os.path.join(self.base_dir, "src", "index.html")

        with open(html_path, "r") as f:
            self.html = f.read()

    def submit_form(self, data: dict):
        """
        Handle form submission from the frontend.
        This method will be called by JavaScript when the form is submitted.
        """
        predicates = self.compute_predicates(data["player"], data["positions"], data["abilities"])
        clause = self.compute_clause(predicates)
        prolog = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        try:
            # connect to the prolog server
            prolog.connect(("localhost", 5000))
            # send the clause that needs to be interogated
            prolog.sendall(clause.encode("utf-8"))
            # wait for the response from the server
            response = prolog.recv(1024).decode("utf-8")
            
            return response
        except Exception as e:
            print("Error while sending the clause to the Prolog server:", e)
        finally:
            # close the connection to the server
            prolog.close()

    def compute_predicates(
        self, 
        player: str,
        positions: list, 
        abilities: list
    ) -> list:
        """
        Given a player and a list of positions & abilities, 
        build the predicates. All predicates are negated because
        all questions are of the type:

        `Is the player X smart, strong and a defender?`

        Return
        ------
        predicates: list
            A list of string that represent the predicates that target the given player.
        """
        predicates = []

        for position in positions:
            predicate = f"n({position}({player}))"
            predicates.append(predicate)

        for ability in abilities:
            predicate = f"n({ability}({player}))"
            predicates.append(predicate)

        return predicates
    
    def compute_clause(
        self,
        predicates: list[str]
    ) -> str:
        """
        Given a list of predicates, build the clause in a format
        that will be understand by the Prolog program.
        """
        inner_clause = ""

        # add all N - 1 predicates
        for i in range(len(predicates) - 1):
            inner_clause += f"{predicates[i]},or," 

        # add the last predicate
        inner_clause += f"{predicates[-1]}"
        # build the clause
        clause = f"['(',{inner_clause},')']\n"

        return clause

