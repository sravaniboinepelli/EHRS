import React from 'react';
import './App.css';
import { Navbar, Nav, Button, NavItem } from "react-bootstrap";
import { Link } from "react-router-dom";

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      drizzleState: null,
      showRules: 0,
      wander: 0,
    }
  }
  componentDidMount() {
    const { drizzle } = this.props;
    this.unsubscribe = drizzle.store.subscribe(() => {
      const drizzleState = drizzle.store.getState();
      if (drizzleState.drizzleStatus.initialized) {
        this.setState({ loading: false, drizzleState });
      }
    });
  }
  componentWillUnmount() {
    this.unsubscribe();
  }
  render() {
    if (this.state.loading) return "Loading Drizzle...";
    return (
      <div className="App">
        <Navbar bg="dark" variant="dark">
          <div className="container">
            <Navbar.Brand href="/">Electronic Health Record System</Navbar.Brand>
            <Nav className="mr-auto">
            </Nav>

          </div>
        </Navbar>
        </div>
    );
  }
}

export default App;
